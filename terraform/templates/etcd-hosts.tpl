[etcd]
%{ for index in range(instance_count) ~}
k8s-control-plane-${index} ansible_host=${floating_ips[index]} ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
%{ endfor ~}