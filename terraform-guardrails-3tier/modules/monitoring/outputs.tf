output "cpu_alarm_names" {
  value = aws_cloudwatch_metric_alarm.ec2_cpu_high[*].alarm_name
}

output "cpu_alarm_arns" {
  value = aws_cloudwatch_metric_alarm.ec2_cpu_high[*].arn
}
