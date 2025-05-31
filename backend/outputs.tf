output "master_public_ip" {
  description = "Public IP of the Kubernetes Master node"
  value       = aws_instance.k8s_master.public_ip
}

output "worker_private_ips" {
  description = "Private IPs of the Kubernetes Worker nodes"
  value       = [
    aws_instance.k8s_worker_1.private_ip,
    aws_instance.k8s_worker_2.private_ip
  ]
}

output "master_private_ip" {
  description = "Private IP of the Kubernetes Master node"
  value       = aws_instance.k8s_master.private_ip
}
