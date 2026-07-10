output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_id" {
  value = aws_instance.bastion.id
}

output "worker1_private_ip" {
  value = aws_instance.worker1.private_ip
}

output "worker2_private_ip" {
  value = aws_instance.worker2.private_ip
}

output "worker1_id" {
  value = aws_instance.worker1.id
}

output "worker2_id" {
  value = aws_instance.worker2.id
}

output "monitoring_public_ip" {
  value = aws_instance.monitoring.public_ip
}

output "monitoring_id" {
  value = aws_instance.monitoring.id
}
