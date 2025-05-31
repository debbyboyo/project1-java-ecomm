output "workstation_public_ip" {
  value = aws_instance.workstation.public_ip
}
output "master_private_ip" {
  value = aws_instance.master.private_ip
}
output "worker_private_ips" {
  value = [for i in aws_instance.worker : i.private_ip]
}
