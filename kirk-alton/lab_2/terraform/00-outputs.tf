# ----------------------------------------------------------------
# OUTPUTS — Application Context
# ----------------------------------------------------------------

output "application_name" {
  description = "Application name"
  value       = local.app
}

output "environment" {
  description = "Environment"
  value       = local.env
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

# ----------------------------------------------------------------
# OUTPUTS — Networking
# ----------------------------------------------------------------

output "vpc_info" {
  description = "VPC ID, Name and CIDR block"
  value = {
    id   = aws_vpc.main.id
    name = aws_vpc.main.tags["Name"]
    cidr = aws_vpc.main.cidr_block
  }
}

# ----------------------------------------------------------------
# OUTPUTS — Database
# ----------------------------------------------------------------

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
# ----------------------------------------------------------------
# OUTPUTS — DNS
# ----------------------------------------------------------------

# Route53 Hosted Zone Info
output "route53_zone" {
  description = "Route53 hosted zone information"

  value = {
    arn          = data.aws_route53_zone.rds_app_zone[0].arn
    id           = data.aws_route53_zone.rds_app_zone[0].zone_id
    name         = data.aws_route53_zone.rds_app_zone[0].name
    name_servers = data.aws_route53_zone.rds_app_zone[0].name_servers
    comment      = data.aws_route53_zone.rds_app_zone[0].comment
  }
}

# ----------------------------------------------------------------
# OUTPUTS — Security WAF
# ----------------------------------------------------------------

# WAF Info
output "waf_info" {
  description = "WAF Web ACL details"

  value = {
    name  = aws_wafv2_web_acl.rds_app.name
    arn   = aws_wafv2_web_acl.rds_app.arn
    scope = aws_wafv2_web_acl.rds_app.scope

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



# ----------------------------------------------------------------
# OUTPUTS — CloudFront (Edge Security / Control Plane)
# ----------------------------------------------------------------

# CloudFront Distribution Info
output "cloudfront_distribution" {
  description = "CloudFront distribution information"

  value = {
    id          = aws_cloudfront_distribution.rds_app.id
    arn         = aws_cloudfront_distribution.rds_app.arn
    domain_name = aws_cloudfront_distribution.rds_app.domain_name
    status      = aws_cloudfront_distribution.rds_app.status
  }
}

# CloudFront TLS Certificate Configuration
output "cloudfront_tls" {
  description = "CloudFront TLS certificate configuration"

  value = {
    certificate_arn          = aws_acm_certificate.rds_app_cf_cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

# ----------------------------------------------------------------
# OUTPUTS — CloudFront (Edge / Public Access)
# ----------------------------------------------------------------

# Public Edge Endpoints
output "cloudfront_endpoints" {
  description = "Public DNS endpoints routed to CloudFront"

  value = {
    apex_domain     = local.root_domain
    subdomain       = local.fqdn
    cloudfront_host = aws_cloudfront_distribution.rds_app.domain_name
  }
}


# ----------------------------------------------------------------
# OUTPUTS — CloudFront (Edge Origin)
# ----------------------------------------------------------------

# CloudFront Origin Configuration
output "cloudfront_origin" {
  description = "CloudFront origin configuration"

  value = {
    origin_domain          = "origin.${local.root_domain}"
    origin_alb_dns         = aws_lb.rds_app_public_alb.dns_name
    origin_protocol_policy = "https-only"
  }
}














# ----------------------------------------------------------------
# OUTPUTS — Load Balancing
# ----------------------------------------------------------------

# RDS App ALB Info
output "rds_app_alb" {
  description = "ALB Information"

  value = {
    application = local.app
    name        = aws_lb.rds_app_public_alb.name
    dns_name    = aws_lb.rds_app_public_alb.dns_name
    zone_id     = aws_lb.rds_app_public_alb.zone_id
    a_record    = aws_route53_record.rds_app_origin_to_alb.name
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

# ----------------------------------------------------------------
# OUTPUTS — Application Access
# ----------------------------------------------------------------

# Application URL
output "application_url" {
  description = "URL for accessing the application"
  value = {
    url = "https://${local.fqdn}"
  }
}

# ----------------------------------------------------------------
# OUTPUTS — Logging & Observability
# ----------------------------------------------------------------

# Logging Info
# Maps in maps is helpful but slants in CLI.
output "logging_info" {
  description = "Logging configuration, resources, and log destinations."

  value = {
    alb_access_logs = {
      enabled = local.alb_log_mode
      bucket = {
        name = try(aws_s3_bucket.alb_logs_bucket[0].bucket, null)
        arn  = try(aws_s3_bucket.alb_logs_bucket[0].arn, null)
      }
      prefix = local.alb_log_mode ? var.alb_access_logs_prefix : null
    }

    waf_direct_logs = {
      enabled = local.waf_log_mode.create_direct_resources
      bucket = {
        name = try(aws_s3_bucket.waf_logs_bucket[0].bucket, null)
        arn  = try(aws_s3_bucket.waf_logs_bucket[0].arn, null)
      }
    }

    waf_firehose_logs = {
      enabled = local.waf_log_mode.create_firehose_resources

      firehose = {
        name = try(aws_kinesis_firehose_delivery_stream.network_telemetry[0].name, null)
        arn  = try(aws_kinesis_firehose_delivery_stream.network_telemetry[0].arn, null)
      }

      firehose_destination = {
        bucket_arn = try(aws_s3_bucket.waf_firehose_logs[0].arn, null)
        prefix     = local.waf_log_mode.create_firehose_resources ? "waf-logs/" : null
      }

      cloudwath_log_groups = {
        cloudwatch_log_groups = {
          vpc_flow_logs = {
            name = aws_cloudwatch_log_group.vpc_flow_log.name
            arn  = aws_cloudwatch_log_group.vpc_flow_log.arn
          }

          waf_direct_logs = {
            enabled = local.waf_log_mode.create_direct_resources
            name    = try(aws_cloudwatch_log_group.waf_logs[0].name, null)
            arn     = try(aws_cloudwatch_log_group.waf_logs[0].arn, null)
          }

          waf_firehose_logs = {
            enabled = local.waf_log_mode.create_firehose_resources
            name    = try(aws_cloudwatch_log_group.waf_firehose_logs[0].name, null)
            arn     = try(aws_cloudwatch_log_group.waf_firehose_logs[0].arn, null)
          }
        }
      }
    }
  }
}