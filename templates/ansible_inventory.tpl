[manager]
%{ for manager in managers ~}
${manager.name} ansible_host=${manager.ip} ansible_user=${user}
%{ endfor ~}

[node]
%{ for node in nodes ~}
${node.name} ansible_host=${node.ip} ansible_user=${user}
%{ endfor ~}

[k8scluster:children]
manager
node