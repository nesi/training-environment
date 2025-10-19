# flexi training environment

This repo sets up a training environment using Open OnDemand within the REANNZ RDC platform using Terraform and Ansible.

[Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and
[Ansible](https://www.ansible.com/) need to be installed on your system to run this.

This setup also requires [Kubernetes Cluster API](https://cluster-api.sigs.k8s.io/) to be running within your NeSI RDC project. To bootstrap one we have the following repo to get you started [NeSI RDC CAPI Bootstrap](https://github.com/nesi/nesi.rdc.kind-bootstrap-capi).

You also need to install [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) on your system.

## Configuration

Configure Terraform using environment variables:

```
export TF_VAR_key_pair="NeSI_RDC_KEYPAIR_NAME"
export TF_VAR_key_file="/path/to/nesi-rdc/private_key"
export TF_VAR_vm_user="ubuntu"
```

where

- `NeSI_RDC_KEYPAIR_NAME` is your `Key Pair` name that is setup in NeSI RDC
- `NeSI_RDC_KEYFILE` is the local location for your ssh key

You will need to download the `clouds.yaml` file from the NeSI RDC dashboard and place it in
`~/.config/openstack/clouds.yaml` so that Terraform can authenticate with NeSI RDC. It is recommended
that you use `Application Credentials` rather then your own credentials.

At the end of your `clouds.yaml` file ensure you ahve the line `verify: false` example below

```
clouds:
  openstack:
    auth:
      auth_url: https://keystone.akl-1.cloud.nesi.org.nz
      application_credential_id: "SECRET"
      application_credential_secret: "SUPER_SECRET"
    region_name: "akl-1"
    interface: "public"
    identity_api_version: 3
    auth_type: "v3applicationcredential"
    verify: false
```

Set environment variables for authenticating with the object store (for the state file), e.g.

```
export AWS_ACCESS_KEY_ID="EC2_User_Access_Token"
export AWS_SECRET_KEY="EC2_User_Secret_Token"
```

where

- `EC2_User_Access_Token` is set to your EC2 access token
- `EC2_User_Secret_Token` is set to your EC2 secret token

If you don't have any EC2 credentials then use the following CLI command to generate new ones:

```
openstack ec2 credentials create
```

Set environment variables for authenticating with AWS Route 53

```
export AWS_ROUTE53_KEY_ID="AWS_ROUTE53_KEY"
export AWS_ROUTE53_SECRET_KEY="AWS_ROUTE53_SECRET"
```

where

- `AWS_ROUTE53_KEY` is set to your AWS access token
- `AWS_ROUTE53_SECRET` is set to your AWS secret token

Install Ansible dependencies:

```
ansible-galaxy install -r requirements.yml
```

Copy template ondemand config and edit:

```
cp vars/ondemand-config.yml.example vars/ondemand-config.yml
```

and edit, in particular set `oidc_settings.OIDCCryptoPassphrase` with a randomly
generated password, e.g. the output of `openssl rand -hex 40`. Also change `keycloak_admin_password`
and `ldap_admin_password`.

You will also need the kube config from the CAPI cluster to so you can create k8s clusters, this should reside within `~/.kube/config`, if running as root then under `/root/.kube/config`

## Note about terraform workspaces

The terraform workspace must have already been created before running the below command.
This will always be the case for the "default" workspace but if you want to create another
workspace you should do it manually by running:

```
cd terraform
terraform init
terraform workspace select -or-create=true <workspace_name>
```

Then continuing with the `ansible-playbook` command below, substituting in the name
of your workspace instead of "default".

## Destroy environment

To destroy a previously created environment run:

```
./deployment.sh destroy [workspace_name]
```

## Create the environment

First, create the terraform resources:

```
./deployment.sh create [workspace_name]
```

By default 2 training user accounts will be created, `training1` and `training2`. Passwords for these users will be
stored in the *users* sub-directory:

```
$ ls users/
password_training1.txt  password_training2.txt
```

More users can be added by changing the `num_users_create` variable in *vars/ondemand-config.yml*.

Separate trainer user accounts are also created, controlled by `num_trainers_create` in *vars/ondemand-config.yml*.
The trainer accounts differ in that they have read access to all the home directories of the training users.

You will need to modify your hosts file with the IP addresses from *host.ini*, on Linux this file is
*/etc/hosts*, on Windows it is *C:\Windows\System32\drivers\etc\hosts*.

```
# /etc/hosts snippet

# this one should be the IP for webnode from host.ini
1.2.3.4 ood.flexi.nesi

# this one should be the IP for servicesnode from host.ini
5.6.7.8 ood-idp.flexi.nesi
```

Connect via [https://ood.flexi.nesi](https://ood.flexi.nesi).
