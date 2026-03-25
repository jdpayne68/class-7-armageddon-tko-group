# ----------------------------------------------------------------
# SAO PAULO — OUTPUTS
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
    application_url   = ""
    cloudfront_domain = ""
    alb_dns_name      = module.compute.rds_app_public_alb_dns_name
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

    # Cross-region dependency (Tokyo DB)
    db_identifier = data.terraform_remote_state.tokyo.outputs.infrastructure_summary.db_identifier
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
# OBSERVABILITY — Logging
# ----------------------------------------------------------------

output "deployment_logging_configuration" {
  description = "Logging configuration for ALB, WAF, and VPC flow logs."
  value       = module.observability.logging_configuration
}

# ----------------------------------------------------------------
# NETWORKING — Transit Gateway (Spoke)
# ----------------------------------------------------------------

output "tgw_id" {
  description = "Transit Gateway ID for the sao paulo spoke."
  value       = module.tgw.tgw_id
}

output "tgw_route_table_id" {
  description = "Transit Gateway route table ID."
  value       = module.tgw.tgw_route_table_id
}

output "vpc_cidr" {
  description = "CIDR block of the sao paulo VPC."
  value       = module.network.vpc_cidr
}