output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.armageddon_vpc01.id
}

output "armageddon_vpce_ssm_id" {
  value = aws_vpc_endpoint.armageddon_vpce_ssm01.id
}

output "armageddon_vpce_logs_id" {
  value = aws_vpc_endpoint.armageddon_vpce_logs01.id
}

output "armageddon_vpce_secrets_id" {
  value = aws_vpc_endpoint.armageddon_vpce_secrets01.id
}

output "armageddon_vpce_s3_id" {
  value = aws_vpc_endpoint.armageddon_vpce_s3_gw01.id
}

output "armageddon_private_ec2_instance_id_bonus" {
  value = aws_instance.armageddon_ec201_private_bonus.id
}

output "armageddon_alb_dns_name" {
  value = aws_lb.armageddon_alb01.dns_name
}

output "armageddon_app_fqdn" {
  value = "${var.app_subdomain}.${var.domain_name}"
}

output "armageddon_target_group_arn" {
  value = aws_lb_target_group.armageddon_tg01.arn
}

output "armageddon_acm_cert_arn" {
  value = aws_acm_certificate.armageddon_acm_cert01.arn
}

output "armageddon_waf_arn" {
  value = var.enable_waf ? aws_wafv2_web_acl.armageddon_waf01[0].arn : null
}

output "armageddon_dashboard_name" {
  value = aws_cloudwatch_dashboard.armageddon_dashboard01.dashboard_name
}
