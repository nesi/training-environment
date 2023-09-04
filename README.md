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
key_file    = "/path/to/flexi/private_key"
```

where

- `FLEXIHPC_KEYPAIR_NAME` is your `Key Pair` name that is setup in FlexiHPC
- `FLEXIHPC_KEYFILE` is the local location for your ssh key

Set environment variables for authenticating with OpenStack and object store (for the state file), e.g.

```
export OS_USERNAME="FLEXIHPC_USER"
export OS_PASSWORD="FLEXIHPC_PASSWORD"
export AWS_ACCESS_KEY_ID="EC2_User_Access_Token"
export AWS_SECRET_KEY="EC2_User_Secret_Token"
```

where

- `FLEXIHPC_USER` is set to your username for the FlexiHPC Platform
- `FLEXIHPC_PASSWORD` is set to your password for the FlexiHPC Platform
- `EC2_User_Access_Token` is set to your EC2 access token
- `EC2_User_Secret_Token` is set to your EC2 secret token

If you don't have any EC2 credentials then use the following CLI command to generate new ones:

```
openstack ec2 credentials create
```

## Create the environment

With these values updated you should be able to run the following commands to setup the environment
```
terraform init
terraform apply
```

## Configure the environment

Currently done manually, not via terraform. Switch to the *ansible* sub-directory and read the
[README.md](ansible/README.md) file there.

## Destroy the environment

Once you are done with the environment running the following command will destroy the environment
```
terraform destroy
```
