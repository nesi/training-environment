[all]
servicesnode ansible_host=${services_floating_ip} 
webnode ansible_host=${webnode_floating_ip}

[all:vars]
vm_private_key_file=${vm_private_key_file}
ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
