# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51.1"
    }
  }

  backend "s3" {
    bucket = "training-environment"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
    use_path_style = "true"
    skip_credentials_validation = "true"    
    endpoints = {
      s3 = "https://object.akl-1.cloud.nesi.org.nz/"
    }
    skip_requesting_account_id = "true"
    skip_s3_checksum = "true"
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  cloud = "openstack"
}
