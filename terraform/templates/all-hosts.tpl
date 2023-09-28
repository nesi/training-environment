[all]
servicesnode ansible_host=${services_floating_ip} ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
webnode ansible_host=${webnode_floating_ip} ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
