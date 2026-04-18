# ----------------------------------------------------------------
# COMPUTE — VARIABLES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# GLOBAL — Identity
# ----------------------------------------------------------------

variable "context" {
  description = "Deployment context (region, app, env, tags)."
  type = object({
    region = string
    app    = string
    env    = string
    tags   = map(string)
  })
}

# ----------------------------------------------------------------
# NAMING — Resource Naming
# ----------------------------------------------------------------

variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "name_suffix" {
  description = "Resource name suffix."
  type        = string
}

# ----------------------------------------------------------------
# COMPUTE — AMI
# ----------------------------------------------------------------

variable "ami_id" {
  description = "Golden AMI for compute instances."
  type        = string
}

# ----------------------------------------------------------------
# NETWORKING — VPC & Subnets
# ----------------------------------------------------------------

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs."
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs."
  type        = list(string)
}

variable "public_subnet_tags" {
  description = "Tags for public subnets."
  type        = map(string)
}

variable "private_app_subnet_tags" {
  description = "Tags for private app subnets."
  type        = map(string)
}

# ----------------------------------------------------------------
# SECURITY — Edge Authentication
# ----------------------------------------------------------------

variable "edge_auth_header_name" {
  description = "Header name for edge-to-origin auth."
  type        = string
}

variable "edge_auth_value" {
  description = "Header value for edge-to-origin auth."
  type        = string
  sensitive   = true
}

# ----------------------------------------------------------------
# IAM — Roles & Instance Profiles
# ----------------------------------------------------------------

variable "iam_role_rds_app_name" {
  description = "IAM role name for app instances."
  type        = string
}

variable "rds_app_instance_profile_name" {
  description = "Instance profile name."
  type        = string
}

# ----------------------------------------------------------------
# SECURITY GROUPS — Access Control
# ----------------------------------------------------------------

variable "rds_app_asg_sg_id" {
  description = "Security group for ASG instances."
  type        = string
}

variable "alb_origin_sg_id" {
  description = "Security group for origin ALB."
  type        = string
}

# ----------------------------------------------------------------
# DNS — Configuration
# ----------------------------------------------------------------

variable "dns_context" {
  description = "DNS config (domain, subdomain, FQDN)."
  type = object({
    root_domain   = string
    app_subdomain = string
    fqdn          = string
  })
}

variable "zone_id" {
  description = "Route53 hosted zone ID."
  type        = string
}

# ----------------------------------------------------------------
# SECRETS — Database Credentials
# ----------------------------------------------------------------

variable "db_secret_arn" {
  description = "Secrets Manager ARN for DB credentials."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY — ALB Logging
# ----------------------------------------------------------------

variable "alb_log_s3" {
  description = "Enable ALB access logs to S3."
  type        = bool
}

variable "alb_access_logs_prefix" {
  description = "S3 prefix for ALB logs."
  type        = string
}

variable "alb_logs_bucket_id" {
  description = "S3 bucket ID for ALB logs."
  type        = string
  default     = null
}

# ----------------------------------------------------------------
# DEPENDENCIES — Readiness Guards
# ----------------------------------------------------------------

variable "ec2_vpc_endpoints_ready" {
  description = "Ensures VPC endpoints exist before compute."
  type        = list(string)
}