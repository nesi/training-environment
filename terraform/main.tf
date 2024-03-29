# Create services instance
resource "openstack_compute_instance_v2" "services_instance" {
  name            = "${terraform.workspace}-ood-services"
  flavor_id       = var.services_flavor_id
  key_pair        = var.key_pair
  security_groups = ["default", "ssh-allow-all", "https", "http"]

  block_device {
    uuid                  = var.services_image_id
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = var.services_volume_size
    delete_on_termination = true
  }

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

# Create webnode instance
resource "openstack_compute_instance_v2" "webnode_instance" {
  name            = "${terraform.workspace}-ood-webnode"
  flavor_id       = var.webnode_flavor_id
  key_pair        = var.key_pair
  security_groups = ["default", "ssh-allow-all", "https", "http"]

  block_device {
    uuid                  = var.webnode_image_id
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = var.webnode_volume_size
    delete_on_termination = true
  }

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

# Generate ansible hosts
locals {
  host_ini_all = templatefile("${path.module}/templates/all-hosts.tpl", {
    services_floating_ip = openstack_networking_floatingip_v2.services_floating_ip.address,
    services_hostname = "${terraform.workspace}-ood-services"
    webnode_floating_ip = openstack_networking_floatingip_v2.webnode_floating_ip.address,
    webnode_hostname = "${terraform.workspace}-ood-webnode"
    vm_private_key_file = var.key_file
  })
}

# Generate ansible host.ini file
locals {
  host_ini_content = templatefile("${path.module}/templates/host.ini.tpl", {
    services_floating_ip = openstack_networking_floatingip_v2.services_floating_ip.address,
    services_hostname = "${terraform.workspace}-ood-services"
    webnode_floating_ip = openstack_networking_floatingip_v2.webnode_floating_ip.address,
    webnode_hostname = "${terraform.workspace}-ood-webnode"
    vm_private_key_file = var.key_file
  })
}

resource "local_file" "host_ini" {
  filename = "../host.ini"
  content  = "${local.host_ini_all}\n${local.host_ini_content}"
  file_permission = "0644"
}
