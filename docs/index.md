# Overview

NeSI ephemeral training environments, running on Flexi HPC, deployed using Terraform and Ansible and using [Open OnDemand](https://osc.github.io/ood-documentation/latest/index.html) as the user interface.

## Architecture 

The training environment consists of multiple VMs:

- web node VM
    * running the Open OnDemand web node software
    * LDAP client
- services node VM
    * LDAP server
    * Keycloak
    * NFS server sharing training user home directories
- kubernetes cluster
    * the users' Open OnDemand apps run here (JupyterLab, RStudio, etc.)
    * each node in the cluster is an LDAP client

## Apps

Open OnDemand [interactive applications](https://osc.github.io/ood-documentation/latest/index.html), such as JupyterLab and RStudio, are used for the training courses. More information about apps can be found [here](/apps).

## User accounts

Within the training environment we create two different types of user accounts, *training* users and *trainer* users, with randomly generated passwords.

- *training* accounts
    * isolated accounts that can only access their own home directory
- *trainer* accounts
    * have read-only access to *training* user home directories, to monitor progress and assist
    * can use the browser based terminal from the OnDemand web interface
