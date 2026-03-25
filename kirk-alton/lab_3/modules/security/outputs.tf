# ----------------------------------------------------------------
# SECURITY — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — Security Groups
# ----------------------------------------------------------------

output "rds_app_asg_sg_id" {
  description = "ASG security group ID."
  value       = aws_security_group.rds_app_asg.id
}

output "alb_origin_sg_id" {
  description = "ALB origin security group ID."
  value       = aws_security_group.alb_origin.id
}

output "private_db_sg_id" {
  description = "Database security group ID."
  value       = aws_security_group.private_db.id
}

# ----------------------------------------------------------------
# OUTPUTS — Logging Configuration
# ----------------------------------------------------------------

output "enable_direct_service_log_delivery" {
  description = "Direct service log delivery flag."
  value       = var.enable_direct_service_log_delivery
}

# ----------------------------------------------------------------
# OUTPUTS — WAF Summary
# ----------------------------------------------------------------

output "waf_info" {
  description = "WAF Web ACL details."

  value = var.create_waf ? {
    name  = aws_wafv2_web_acl.rds_app[0].name
    arn   = aws_wafv2_web_acl.rds_app[0].arn
    scope = aws_wafv2_web_acl.rds_app[0].scope

    rules = [
      for rule in aws_wafv2_web_acl.rds_app[0].rule : {
        name     = rule.name
        priority = rule.priority
        metric   = rule.visibility_config[0].metric_name
        managed_rule_group = try(
          rule.statement[0].managed_rule_group_statement[0].name,
          null
        )
      }
    ]
  } : null
}

# ----------------------------------------------------------------
# OUTPUTS — WAF Identifiers
# ----------------------------------------------------------------

output "rds_app_waf_arn" {
  description = "WAF ARN."
  value       = var.create_waf ? aws_wafv2_web_acl.rds_app[0].arn : null
}

output "rds_app_waf_id" {
  description = "WAF ID."
  value       = var.create_waf ? aws_wafv2_web_acl.rds_app[0].id : null
}

output "rds_app_waf_name" {
  description = "WAF name."
  value       = var.create_waf ? aws_wafv2_web_acl.rds_app[0].name : null
}

output "rds_app_waf_capacity" {
  description = "WAF capacity units."
  value       = var.create_waf ? aws_wafv2_web_acl.rds_app[0].capacity : null
}