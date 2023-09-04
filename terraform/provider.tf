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
    endpoint   = "https://object.akl-1.cloud.nesi.org.nz/"
    sts_endpoint = "https://object.akl-1.cloud.nesi.org.nz/"
    region = "us-east-1"
    force_path_style = "true"
    skip_credentials_validation = "true"
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  cloud = "openstack"
}
