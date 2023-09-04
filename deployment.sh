case $1 in
"destroy")
    ansible-playbook setup-infra.yml -e operation=destroy
    ;;
"create")
    ansible-playbook ./ansible/setup-infra.yml -e operation=create
    ansible-playbook -i ./ansible/host.ini ./ansible/setup-training-environment.yml -u ${var.vm_user} --key-file '${var.key_file}'
    ;;
esac