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
}

variable "key_file" {
  description = "Path to local SSH private key associated with Flexi key_pair, used for provisioning"
}

variable "services_flavor_id" {
  description = "FlexiHPC Flavor ID for services instance, Defaults to balanced1.4cpu8ram"
  default     = "e07cfee1-43af-4bf6-baac-3bdf7c1b88f8"
}

variable "services_image_id" {
  description = "FlexiHPC Image ID for services instance, Defaults to NeSI-FlexiHPC-Ubuntu-Jammy_22.04"
  default     = "ee420ef7-8baa-4a7d-adf1-2fde47f58fa5"
}

variable "services_volume_size" {
  description = "The size of the services volume in gigabytes, defaults to 30"
  default     = "30"
}

variable "webnode_flavor_id" {
  description = "FlexiHPC Flavor ID for services instance, Defaults to balanced1.4cpu8ram"
  default     = "e07cfee1-43af-4bf6-baac-3bdf7c1b88f8"
}

variable "webnode_image_id" {
  description = "FlexiHPC Image ID for services instance, Defaults to NeSI-FlexiHPC-Ubuntu-Jammy_22.04"
  default     = "ee420ef7-8baa-4a7d-adf1-2fde47f58fa5"
}

variable "webnode_volume_size" {
  description = "The size of the webnode volume in gigabytes, defaults to 30"
  default     = "30" 
}

variable "vm_user" {
  description = "FlexiHPC VM user"
  default = "ubuntu"
}

# variable "kube_config" {
#   description = "kube config file"
# }

# variable "clouds_yaml" {
#   description = "clouds.yaml file for connecting to NeSI RDC"
# }
