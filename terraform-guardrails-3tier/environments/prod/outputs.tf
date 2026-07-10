output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "waf_web_acl_arn" {
  value = module.waf.web_acl_arn
}

output "bastion_public_ip" {
  value = module.ec2.bastion_public_ip
}

output "monitoring_public_ip" {
  value = module.ec2.monitoring_public_ip
}

output "grafana_url" {
  value = "http://${module.ec2.monitoring_public_ip}:3000"
}

output "prometheus_url" {
  value = "http://${module.ec2.monitoring_public_ip}:9090"
}

output "grafana_dashboard" {
  value = "Project Monitoring / Three Tier Project - Grafana Monitoring"
}

output "application_metrics_targets" {
  value = [
    "http://${module.ec2.worker1_private_ip}:8000/metrics",
    "http://${module.ec2.worker2_private_ip}:8000/metrics"
  ]
}
