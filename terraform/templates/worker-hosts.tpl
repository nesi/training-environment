[kube_node]
%{ for index in range(instance_count) ~}
k8s-worker-node-${index} ansible_host=${floating_ips[index]} ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
%{ endfor ~}