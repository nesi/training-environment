#!/bin/bash -e

case $1 in
"destroy")
    ansible-playbook setup-infra.yml -e operation=destroy -e terraform_workspace=${2:-default}
    ;;
"create")
    ansible-playbook setup-infra.yml -e operation=create -e terraform_workspace=${2:-default}
    ansible-playbook -i host.ini setup-training-environment.yml -u ubuntu --key-file ~/.ssh/id_flexi
    ;;
esac
