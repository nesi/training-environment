[servers]
servicesnode ansible_host=${services_floating_ip} hostname=${services_hostname}
webnode ansible_host=${webnode_floating_ip} hostname=${webnode_hostname}

[servers:vars]
vm_private_key_file=${vm_private_key_file}
ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

[ldap_clients]

[ldap_clients:vars]
vm_private_key_file=${vm_private_key_file}
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

