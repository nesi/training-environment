variable "tenant_name" {
  description = "FlexiHPC project Name"
  default = "NeSI-Training-Test"
}

variable "auth_url" {
  description = "FlexiHPC authentication URL"
  default = "https://keystone.akl-1.cloud.nesi.org.nz/v3"
}

variable "region" {
  description = "FlexiHPC region"
  default = "akl-1"
}

variable "key_pair" {
  description = "FlexiHPC SSH Key Pair name"
  default = "kahus-key"
}

variable "key_file" {
  description = "Path to local SSH private key associated with Flexi key_pair, used for provisioning"
  default = "~/.ssh/id_flexi"
}

variable "services_flavor_id" {
  description = "FlexiHPC Flavor ID for services instance, Defaults to devtest1.4cpu4ram"
  default     = "4ec785be-a422-4207-9daa-cbb71c61f9ed" 
}

variable "services_image_id" {
  description = "FlexiHPC Image ID for services instance, Defaults to ubuntu-jammy-server-cloudimg"
  default     = "1a0480d1-55c8-4fd7-8c7a-8c26e52d8cbd" 
}

variable "webnode_flavor_id" {
  description = "FlexiHPC Flavor ID for services instance, Defaults to balanced1.4cpu8ram"
  default     = "e07cfee1-43af-4bf6-baac-3bdf7c1b88f8" 
}

variable "webnode_image_id" {
  description = "FlexiHPC Image ID for services instance, Defaults to Ubuntu-Jammy-22.04"
  default     = "a5c9b7b2-e77b-4094-99ac-db0cf5181da5" 
}

variable "control_plane_instance_count" {
  description = "Number of compute instances to create as control planes"
  default     = 1
}

variable "control_plane_flavor_id" {
  description = "FlexiHPC Flavor ID, Defaults to devtest1.1cpu1ram"
  default     = "ee55c523-9803-4296-91be-1c34e986baaa" 
}

variable "worker_instance_count" {
  description = "Number of compute instances to create as workers"
  default     = 1
}

variable "worker_flavor_id" {
  description = "FlexiHPC Flavor ID for workers, Defaults to devtest1.1cpu1ram"
  default     = "ee55c523-9803-4296-91be-1c34e986baaa" 
}

variable "k8s_image_id" {
  description = "FlexiHPC Image ID, Defaults to Ubuntu-Jammy-22.04"
  default     = "1a0480d1-55c8-4fd7-8c7a-8c26e52d8cbd" 
}

variable "k8s_security_groups" {
  description = "A list of security groups to add to the K8 VM's"
  default     = ["Kahus-IP-Allow", "SSH Allow All", "default"] 
}

variable "vm_user" {
  description = "FlexiHPC VM user"
  default = "ubuntu"
}

variable "extra_public_keys" {
  description = "Additional SSH public keys to add to the authorized_keys file on provisioned nodes"
  type = list(string)
  default = []
}
