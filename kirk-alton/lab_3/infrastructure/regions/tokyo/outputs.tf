# ----------------------------------------------------------------
# TOKYO — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# CONTEXT — Deployment Identity
# ----------------------------------------------------------------

output "application_context" {
  description = "Deployment context information."

  value = {
    application = local.context.app
    environment = local.context.env
    region      = local.context.region
  }
}

output "deployment_metadata" {
  description = "Deployment metadata."

  value = {
    region      = local.context.region
    environment = local.context.env
    application = local.context.app
    vpc_id      = module.network.vpc_id
  }
}

# ----------------------------------------------------------------
# ACCESS — Application Endpoints
# ----------------------------------------------------------------

output "application_access" {
  description = "Primary application endpoints."

  value = {
    application_url   = "" # FIXME
    cloudfront_domain = "" # FIXME
    alb_dns_name      = module.compute.rds_app_public_alb_dns_name
    database_endpoint = module.database.db_endpoint
  }
}

output "rds_app_public_alb_dns_name" {
  description = "DNS name of the public ALB used as the CloudFront origin."
  value       = module.compute.rds_app_public_alb_dns_name
}

output "rds_app_public_alb_zone_id" {
  description = "Hosted zone ID of the public ALB used for Route53 alias records."
  value       = module.compute.rds_app_public_alb_zone_id
}

output "zone_id" {
  description = "Route53 hosted zone ID."
  value       = module.dns.zone_id
}

# ----------------------------------------------------------------
# DATABASE — Core Outputs
# ----------------------------------------------------------------

output "db_identifier" {
  description = "RDS instance identifier."
  value       = module.database.db_identifier
}

output "db_secret_arn" {
  description = "ARN of the database secret."
  value       = module.database.db_secret_arn
}

# ----------------------------------------------------------------
# COMPUTE — Capacity & TLS
# ----------------------------------------------------------------

output "compute_capacity" {
  description = "Auto Scaling configuration."

  value = {
    asg_name         = module.compute.rds_app_asg_name
    desired_capacity = module.compute.rds_app_asg_desired_capacity
    min_size         = module.compute.rds_app_asg_min_size
    max_size         = module.compute.rds_app_asg_max_size
  }
}

output "rds_app_cert_arn" {
  description = "ACM certificate ARN used by the ALB."
  value       = module.compute.rds_app_cert_arn
}

# ----------------------------------------------------------------
# INFRASTRUCTURE — Network Summary
# ----------------------------------------------------------------

output "infrastructure_summary" {
  description = "High-level infrastructure summary."

  value = {
    vpc_id   = module.network.vpc_id
    vpc_cidr = module.network.vpc_cidr

    public_subnets       = module.network.public_subnet_ids
    private_app_subnets  = module.network.private_app_subnet_ids
    private_data_subnets = module.network.private_data_subnet_ids

    alb_name      = module.compute.rds_app_public_alb_name
    asg_name      = module.compute.rds_app_asg_name
    db_identifier = module.database.db_identifier
  }
}

# ----------------------------------------------------------------
# SECURITY — Summary & Edge Auth
# ----------------------------------------------------------------

output "security_summary" {
  description = "Security configuration summary."

  value = {
    waf_name     = module.security.rds_app_waf_name
    waf_capacity = module.security.rds_app_waf_capacity

    alb_security_group = module.security.alb_origin_sg_id
    app_security_group = module.security.rds_app_asg_sg_id
    db_security_group  = module.security.private_db_sg_id
  }
}

output "edge_auth_value" {
  description = "Secret header value used for CloudFront → ALB authentication."
  value       = random_password.edge_auth_value.result
  sensitive   = true
}

# ----------------------------------------------------------------
# OBSERVABILITY — Logging & Metrics
# ----------------------------------------------------------------

output "deployment_logging_configuration" {
  description = "Logging configuration for ALB, WAF, and VPC flow logs."
  value       = module.observability.logging_configuration
}

output "vpc_flow_log_group_arn" {
  description = "CloudWatch Log Group ARN for VPC Flow Logs."
  value       = module.observability.vpc_flow_log_group_arn
}

output "waf_direct_log_group_arn" {
  description = "CloudWatch Log Group ARN for direct WAF logging."
  value       = module.observability.waf_direct_log_group_arn
}

output "waf_firehose_log_group_arn" {
  description = "CloudWatch Log Group ARN for WAF Firehose logging."
  value       = try(module.observability.waf_firehose_log_group_arn, null)
}

output "waf_firehose_logs_bucket_arn" {
  description = "S3 bucket ARN for WAF Firehose log delivery."
  value       = try(module.observability.waf_firehose_logs_bucket_arn, null)
}

# ----------------------------------------------------------------
# IAM — Shared Roles
# ----------------------------------------------------------------

output "rds_app_role_name" {
  description = "IAM role name for EC2 instances."
  value       = module.iam.rds_app_role_name
}

output "rds_app_instance_profile_name" {
  description = "IAM instance profile name."
  value       = module.iam.rds_app_instance_profile_name
}

output "vpc_flow_log_role_arn" {
  description = "IAM role ARN for VPC Flow Logs."
  value       = module.iam.vpc_flow_log_role_arn
}

# ----------------------------------------------------------------
# NETWORKING — Transit Gateway (Hub)
# ----------------------------------------------------------------

output "tgw_id" {
  description = "Transit Gateway ID for Tokyo hub."
  value       = module.tgw.tgw_id
}

output "tgw_route_table_id" {
  description = "Transit Gateway route table ID."
  value       = module.tgw.tgw_route_table_id
}

output "vpc_cidr" {
  description = "CIDR block of the Tokyo VPC."
  value       = module.network.vpc_cidr
}