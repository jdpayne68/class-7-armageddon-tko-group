output "application_name" {
  description = "Application name"
  value       = var.application
}

output "environment" {
  description = "Environment"
  value       = local.environment
}

output "region_choice" {
  description = "Region choice (number)"
  value       = var.region_choice
}

output "region" {
  description = "Region (name)"
  value       = local.region
}

output "availability_zones" {
  description = "Avialability Zones"
  value       = data.aws_availability_zones.available.names
}

output "vpc_info" {
  description = "VPC ID, Name and CIDR block"
  value = {
    id   = aws_vpc.main.id
    name = aws_vpc.main.tags["Name"]
    cidr = aws_vpc.main.cidr_block
  }
}


output "rds_info" {
  description = "RDS Information"
  value = {
    name     = aws_db_instance.lab_mysql.tags["Name"]
    endpoint = aws_db_instance.lab_mysql.endpoint
    address  = aws_db_instance.lab_mysql.address
    port     = aws_db_instance.lab_mysql.port
  }
}

output "rds_subnets" {
  value       = aws_db_subnet_group.lab_mysql.subnet_ids
  description = "RDS Subnets"
}


# Route53 Hosted Zone Info
output "route53_zone" {
  description = "Route53 hosted zone information"

  value = {
    arn          = data.aws_route53_zone.rds_app_zone.arn
    id           = data.aws_route53_zone.rds_app_zone.zone_id
    name         = data.aws_route53_zone.rds_app_zone.name
    name_servers = data.aws_route53_zone.rds_app_zone.name_servers
    comment      = data.aws_route53_zone.rds_app_zone.comment
  }
}

# WAF Info
output "waf_info" {
  description = "WAF Web ACL details"

  value = {
    name  = aws_wafv2_web_acl.rds_app.name
    arn   = aws_wafv2_web_acl.rds_app.arn
    scope = aws_wafv2_web_acl.rds_app.scope

    # Use try() with .managed_rule_group_statement and null to avoid errors if the rule isn't a managed group.
    rules = [
      for rule in aws_wafv2_web_acl.rds_app.rule : {
        name     = rule.name
        priority = rule.priority
        metric   = rule.visibility_config[0].metric_name
        managed_rule_group = try(
          rule.statement[0].managed_rule_group_statement[0].name,
          null
        )
      }
    ]
  }
}

# RDS App ALB Info
output "rds_app_alb" {
  description = "ALB Information"

  value = {
    application = local.application
    name        = aws_lb.rds_app_public_alb.name
    dns_name    = aws_lb.rds_app_public_alb.dns_name
    zone_id     = aws_lb.rds_app_public_alb.zone_id
    a_record    = aws_route53_record.rds_app_alias.name
  }
}

# RDS App ALB Listeners
output "alb_listeners" {
  description = "ALB listener ports"
  value = {
    http  = aws_lb_listener.rds_app_http_80.port
    https = aws_lb_listener.rds_app_https_443.port
  }
}

# Application URL
output "application_url" {
  description = "URL for accessing the application"
  value = {
    url = "https://${local.fqdn}"
  }
}