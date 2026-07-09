output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "master_private_ip" {
  value = aws_instance.master.private_ip
}

output "worker1_private_ip" {
  value = aws_instance.worker1.private_ip
}

output "worker2_private_ip" {
  value = aws_instance.worker2.private_ip
}

output "monitoring_public_ip" {
  value = aws_instance.monitoring.public_ip
}

output "master_id" {
  value = aws_instance.master.id
}

output "worker1_id" {
  value = aws_instance.worker1.id
}

output "worker2_id" {
  value = aws_instance.worker2.id
}