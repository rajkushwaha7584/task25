#############################################
# EC2 CPU Alarms
#############################################

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  count = length(var.instance_ids)

  alarm_name          = "${var.project_name}-${var.environment}-${var.instance_names[count.index]}-cpu-high"
  alarm_description   = "High CPU alarm for ${var.instance_names[count.index]}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = var.instance_ids[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions

  tags = {
    Name = "${var.project_name}-${var.environment}-${var.instance_names[count.index]}-cpu-high"
  }
}
