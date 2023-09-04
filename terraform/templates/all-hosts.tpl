[all]
%{ for index in range(instance_count) ~}
k8s-control-plane-${index} ansible_host=${floating_ips[index]} ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
%{ endfor ~}
%{ for index in range(worker_instance_count) ~}
k8s-worker-node-${index} ansible_host=${worker_floating_ips[index]} ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
%{ endfor ~}
servicesnode ansible_host=${services_floating_ip}
webnode ansible_host=${webnode_floating_ip}
