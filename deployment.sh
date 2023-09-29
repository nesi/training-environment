#!/bin/bash -e

case $1 in
"destroy")
    ansible-playbook setup-infra.yml -e operation=destroy -e terraform_workspace=${2:-default}
    # Need to also run this command 'kubectl delete cluster CLUSTER_NAME'
    # which ill probs base of the terraform workspace
    kubectl delete cluster ${2:-default}
    ;;
"create")
    ansible-playbook setup-infra.yml -e operation=create -e terraform_workspace=${2:-default}
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i host.ini setup-training-environment.yml \
        -u ${TF_VAR_vm_user} --key-file '${TF_VAR_key_file}' -e terraform_workspace=${2:-default} \
        -e "num_users_create=${NUM_USERS:-2}"
    ;;
esac
