# Create services instance
resource "openstack_compute_instance_v2" "services_instance" {
  name            = "${terraform.workspace}-ood-services"
  flavor_id       = var.services_flavor_id
  image_id        = var.services_image_id
  key_pair        = var.key_pair
  security_groups = ["default", "SSH Allow All", "https"]

  network {
    name = var.tenant_name
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "services_floating_ip" {
  pool  = "external"
}

# Assign floating ip
resource "openstack_compute_floatingip_associate_v2" "services_floating_ip_association" {
  floating_ip  = openstack_networking_floatingip_v2.services_floating_ip.address
  instance_id  = openstack_compute_instance_v2.services_instance.id
}

# add extra public keys to services instance
resource "null_resource" "services_extra_keys" {
  depends_on = [openstack_compute_floatingip_associate_v2.services_floating_ip_association]
  count = length(var.extra_public_keys) > 0 ? 1 : 0

  connection {
    user = var.vm_user
    private_key = file(var.key_file)
    host = "${openstack_networking_floatingip_v2.services_floating_ip.address}"
  }

  provisioner "remote-exec" {
    inline = [for pkey in var.extra_public_keys : "echo ${pkey} >> $HOME/.ssh/authorized_keys"]
  }
}

# Create webnode instance
resource "openstack_compute_instance_v2" "webnode_instance" {
  name            = "${terraform.workspace}-ood-webnode"
  flavor_id       = var.webnode_flavor_id
  image_id        = var.webnode_image_id
  key_pair        = var.key_pair
  security_groups = ["default", "SSH Allow All", "https"]

  network {
    name = var.tenant_name
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "webnode_floating_ip" {
  pool  = "external"
}

# Assign floating ip
resource "openstack_compute_floatingip_associate_v2" "webnode_floating_ip_association" {
  floating_ip  = openstack_networking_floatingip_v2.webnode_floating_ip.address
  instance_id  = openstack_compute_instance_v2.webnode_instance.id
}

# Create control planes
resource "openstack_compute_instance_v2" "control_plane_instance" {
  count = var.control_plane_instance_count

  name            = "${terraform.workspace}-control-plane-${count.index}"
  flavor_id       = var.control_plane_flavor_id
  image_id        = var.k8s_image_id
  key_pair        = var.key_pair
  security_groups = var.k8s_security_groups

  network {
    name = var.tenant_name
  }  

  metadata = {
    ssh_user         = "ubuntu"
    k8s_groups       = "kube_control_plane,k8s_cluster"
  }
}

# Create floating ip for control plane
resource "openstack_networking_floatingip_v2" "control_plane_floating_ip" {
  count = var.control_plane_instance_count
  pool  = "external"
}

# Assign floating ip to control plane
resource "openstack_compute_floatingip_associate_v2" "control_plane_floating_ip_association" {
  for_each     = { for idx, ip in openstack_networking_floatingip_v2.control_plane_floating_ip : idx => ip }
  floating_ip  = each.value.address
  instance_id  = openstack_compute_instance_v2.control_plane_instance[each.key].id
}

# Create workers
resource "openstack_compute_instance_v2" "worker_instance" {
  count = var.worker_instance_count

  name            = "${terraform.workspace}-worker-node-${count.index}"
  flavor_id       = var.worker_flavor_id
  image_id        = var.k8s_image_id
  key_pair        = var.key_pair
  security_groups = var.k8s_security_groups

  network {
    name = var.tenant_name
  }

  metadata = {
    ssh_user         = "ubuntu"
    k8s_groups       = "kube_node,k8s_cluster"
  }
}

# Create floating ip for workers
resource "openstack_networking_floatingip_v2" "worker_floating_ip" {
  count = var.worker_instance_count
  pool  = "external"
}

# Assign floating ip to workers
resource "openstack_compute_floatingip_associate_v2" "worker_floating_ip_association" {
  for_each     = { for idx, ip in openstack_networking_floatingip_v2.worker_floating_ip : idx => ip }
  floating_ip  = each.value.address
  instance_id  = openstack_compute_instance_v2.worker_instance[each.key].id
}

# add extra public keys to webnode instance
resource "null_resource" "webnode_extra_keys" {
  depends_on = [openstack_compute_floatingip_associate_v2.webnode_floating_ip_association]
  count = length(var.extra_public_keys) > 0 ? 1 : 0

  connection {
    user = var.vm_user
    private_key = file(var.key_file)
    host = "${openstack_networking_floatingip_v2.webnode_floating_ip.address}"
  }

  provisioner "remote-exec" {
    inline = [for pkey in var.extra_public_keys : "echo ${pkey} >> $HOME/.ssh/authorized_keys"]
  }
}

# Generate ansible hosts
locals {
  host_ini_all = templatefile("${path.module}/templates/all-hosts.tpl", {
    instance_count = var.control_plane_instance_count,
    floating_ips   = openstack_networking_floatingip_v2.control_plane_floating_ip[*].address,
    worker_instance_count = var.worker_instance_count,
    worker_floating_ips   = openstack_networking_floatingip_v2.worker_floating_ip[*].address,
    services_floating_ip = openstack_networking_floatingip_v2.services_floating_ip.address,
    webnode_floating_ip = openstack_networking_floatingip_v2.webnode_floating_ip.address,
  })
}

# Generate ansible control plane hosts
locals {
  host_ini_control_planes = templatefile("${path.module}/templates/control-plane-hosts.tpl", {
    instance_count = var.control_plane_instance_count,
    floating_ips   = openstack_networking_floatingip_v2.control_plane_floating_ip[*].address,
  })
}

# Generate ansible etcd hosts
locals {
  host_ini_etcd = templatefile("${path.module}/templates/etcd-hosts.tpl", {
    instance_count = var.control_plane_instance_count,
    floating_ips   = openstack_networking_floatingip_v2.control_plane_floating_ip[*].address,
  })
}

# Generate ansible worker hosts
locals {
  host_ini_workers = templatefile("${path.module}/templates/worker-hosts.tpl", {
    instance_count = var.worker_instance_count,
    floating_ips   = openstack_networking_floatingip_v2.worker_floating_ip[*].address,
  })
}

# Generate ansible host.ini file
locals {
  host_ini_content = templatefile("${path.module}/templates/host.ini.tpl", {
    services_floating_ip = openstack_networking_floatingip_v2.services_floating_ip.address,
    webnode_floating_ip = openstack_networking_floatingip_v2.webnode_floating_ip.address,
  })
}

resource "local_file" "host_ini" {
  filename = "../host.ini"
  content  = "${local.host_ini_all}\n${local.host_ini_control_planes}\n${local.host_ini_etcd}\n${local.host_ini_workers}\n${local.host_ini_content}\n[k8s_cluster:children]\nkube_control_plane\nkube_node"
  file_permission = "0644"
}

# resource "null_resource" "wait_for_nodes" {
#   depends_on = [openstack_compute_instance_v2.webnode_instance, openstack_compute_instance_v2.services_instance]

#   # Introduce a delay using the local-exec provisioner.
#   provisioner "local-exec" {
#     command = "sleep 60"  # Wait for 300 seconds (5 minutes) in this example.
#   }
# }

# Run ansible playbook
#resource "null_resource" "run_ansible_playbook" {
#  depends_on = [local_file.host_ini, null_resource.wait_for_nodes]
#
#  provisioner "local-exec" {
#    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/host.ini ansible/ping_test.yml -u ${var.vm_user} --key-file '${var.key_file}'"
#    working_dir = path.module
#  }
#}

# Run ansible playbook
# resource "null_resource" "run_ansible_playbook" {
#   depends_on = [local_file.host_ini, null_resource.wait_for_nodes]

#   provisioner "local-exec" {
#     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i host.ini setup-training-environment.yml -u ${var.vm_user} --key-file '${var.key_file}'"
#     working_dir = "ansible"
#   }
# }
