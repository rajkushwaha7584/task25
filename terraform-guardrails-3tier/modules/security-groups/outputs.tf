output "alb_sg" {
  value = aws_security_group.alb.id
}

output "master_sg" {
  value = aws_security_group.master.id
}

output "worker_sg" {
  value = aws_security_group.worker.id
}

output "postgres_sg" {
  value = aws_security_group.postgres.id
}

output "monitoring_sg" {
  value = aws_security_group.monitoring.id
}