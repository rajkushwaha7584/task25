output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "waf_web_acl_arn" {
  value = module.waf.web_acl_arn
}

output "cpu_alarm_names" {
  value = module.monitoring.cpu_alarm_names
}

output "bastion_public_ip" {
  value = module.ec2.bastion_public_ip
}
