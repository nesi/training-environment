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
    ansible-playbook -i host.ini setup-training-environment.yml -u ubuntu --key-file ~/.ssh/id_flexi -e terraform_workspace=${2:-default}
    ;;
esac
