# ----------------------------------------------------------------
# SAO PAULO — VARIABLES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# GLOBAL — Identity
# ----------------------------------------------------------------

variable "region" {
  description = "AWS region."
  type        = string
  default     = "sa-east-1"
}

variable "app" {
  description = "Application name."
  type        = string
  default     = "rds-app"
}

variable "env" {
  description = "Deployment environment (dev, test, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "Environment must be: dev, test, or prod."
  }
}

# ----------------------------------------------------------------
# NETWORKING — VPC
# ----------------------------------------------------------------

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.10.0.0/16"
}

# ----------------------------------------------------------------
# DNS — Route53
# ----------------------------------------------------------------

variable "manage_route53_in_terraform" {
  description = "Manage Route53 hosted zone and records."
  type        = bool
  default     = false
}

variable "route53_private_zone" {
  description = "Whether the hosted zone is private."
  type        = bool
  default     = false

  validation {
    condition     = var.route53_private_zone == false
    error_message = "Requires public Route53 zone."
  }
}

variable "is_dns_writer" {
  description = "Whether this stack creates DNS records."
  type        = bool
  default     = false
}

variable "root_domain" {
  description = "Root DNS domain."
  type        = string
  default     = "kirkdevsecops.com"
}

# ----------------------------------------------------------------
# COMPUTE — EC2 / AMI
# ----------------------------------------------------------------

variable "ami_id" {
  description = "Golden AMI for compute instances."
  type        = string
  default     = "ami-0569b9007d23630c2"
}

# ----------------------------------------------------------------
# OBSERVABILITY — DB + WAF
# ----------------------------------------------------------------

variable "enable_db_observability" {
  description = "Enable DB observability resources."
  type        = bool
  default     = false
}

variable "waf_log_destination" {
  description = "WAF log destination: cloudwatch, s3, or firehose."
  type        = string
  default     = "cloudwatch"

  validation {
    condition     = contains(["cloudwatch", "s3", "firehose"], lower(var.waf_log_destination))
    error_message = "Must be: cloudwatch, s3, or firehose."
  }
}

variable "waf_log_retention_days" {
  description = "WAF log retention (days)."
  type        = number
  default     = 14
}

variable "enable_waf_sampled_requests_only" {
  description = "Enable sampled request visibility only."
  type        = bool
  default     = false
}

variable "enable_direct_service_log_delivery" {
  description = "Enable direct service log delivery to CloudWatch."
  type        = bool
  default     = false
}

# ----------------------------------------------------------------
# LOAD BALANCING — ALB
# ----------------------------------------------------------------

variable "alb_access_logs_prefix" {
  description = "S3 prefix for ALB access logs."
  type        = string
  default     = "alb-access-logs"
}

variable "alb_log_s3" {
  description = "Enable ALB access logs to S3."
  type        = bool
  default     = true
}

# ----------------------------------------------------------------
# CONNECTIVITY — Transit Gateway
# ----------------------------------------------------------------

variable "tgw_role" {
  description = "Transit Gateway role (hub or spoke)."
  type        = string
  default     = "spoke"

  validation {
    condition     = contains(["hub", "spoke"], lower(var.tgw_role))
    error_message = "Must be: hub or spoke."
  }
}

variable "tgw_tags" {
  description = "Transit Gateway tags."
  type        = map(string)

  default = {
    Region       = "saopaulo"
    Role         = "spoke"
    Component    = "network"
    Connectivity = "inter-vpc"
    Scope        = "regional"
  }
}

# ----------------------------------------------------------------
# MISC — Metadata
# ----------------------------------------------------------------

variable "demo_owner" {
  description = "Demo owner tag."
  type        = string
  default     = "DevSecOpsTeam"
}