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


# Generate ansible host.ini file
locals {
  host_ini_content = templatefile("${path.module}/templates/host.ini.tpl", {
    services_floating_ip = openstack_networking_floatingip_v2.services_floating_ip.address,
    webnode_floating_ip = openstack_networking_floatingip_v2.webnode_floating_ip.address,
  })
}

resource "local_file" "host_ini" {
  filename = "../ansible/host.ini"
  content  = local.host_ini_content
  file_permission = "0644"
}

resource "null_resource" "wait_for_nodes" {
  depends_on = [openstack_compute_instance_v2.webnode_instance, openstack_compute_instance_v2.services_instance]

  # Introduce a delay using the local-exec provisioner.
  provisioner "local-exec" {
    command = "sleep 60"  # Wait for 300 seconds (5 minutes) in this example.
  }
}

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