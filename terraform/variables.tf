variable "tenant_name" {
  description = "FlexiHPC project Name"
  default = "NeSI-Training-Test-DONT-USE"
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
  description = "FlexiHPC Flavor ID for services instance, Defaults to devtest1.4cpu4ram"
  default     = "2d02e6a4-3937-4ed3-951a-8e27867ff53e" 
}

variable "services_image_id" {
  description = "FlexiHPC Image ID for services instance, Defaults to ubuntu-jammy-server-cloudimg"
  default     = "1a0480d1-55c8-4fd7-8c7a-8c26e52d8cbd" 
}

variable "services_volume_size" {
  description = "The size of the services volume in gigabytes, defaults to 30"
  default     = "400" 
}

variable "webnode_flavor_id" {
  description = "FlexiHPC Flavor ID for services instance, Defaults to balanced1.4cpu8ram"
  default     = "674fa81a-69c7-4bf7-b3a9-59989fb63618" 
}

variable "webnode_image_id" {
  description = "FlexiHPC Image ID for services instance, Defaults to ubuntu-jammy-server-cloudimg"
  default     = "1a0480d1-55c8-4fd7-8c7a-8c26e52d8cbd" 
}

variable "webnode_volume_size" {
  description = "The size of the webnode volume in gigabytes, defaults to 30"
  default     = "30" 
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

# variable "kube_config" {
#   description = "kube config file"
# }

# variable "clouds_yaml" {
#   description = "clouds.yaml file for connecting to NeSI RDC"
# }
