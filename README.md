# flexi training environment

**Work in progress**

This repo sets up a training environment using Open OnDemand within the FlexiHPC platform using Terraform and Ansible.

[Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and
[Ansible](https://www.ansible.com/) need to be installed on your system to run this.

First copy the config file:

```
cp terraform.tfvars.example terraform.tfvars
```

Inside the `terraform.tfvars` file is some user configuration required.

```
key_pair    = "FLEXIHPC_KEYPAIR_NAME"
key_file    = "FLEXIHPC_KEYFILE"

vm_user     = "ubuntu"
```

where

- `FLEXIHPC_KEYPAIR_NAME` is your `Key Pair` name that is setup in FlexiHPC
- `FLEXIHPC_KEYFILE` is the local location for your ssh key
- *vm_user* can usually be left the same unless you change to a different image

Set environment variables for authenticating with OpenStack using environment variables, e.g.

```
export OS_USERNAME="FLEXIHPC_USER"
export OS_PASSWORD="FLEXIHPC_PASSWORD"
```

where

- `FLEXIHPC_USER` is set to your username for the FlexiHPC Platform
- `FLEXIHPC_PASSWORD` is set to your password for the FlexiHPC Platform

## Create the environment

With these values updated you should be able to run the following commands to setup the environment
```
terraform init
terraform apply
```
This will ask for your FlexiHPC password before it does its plan stage for Terraform

## Configure the environment

Currently done manually, not via terraform. Switch to the *ansible* sub-directory and read the
[README.md](ansible/README.md) file there.

## Destroy the environment

Once you are done with the environment running the following command will destroy the environment
```
terraform destroy
```
