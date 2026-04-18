# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — Account and Networking Inputs
# ----------------------------------------------------------------

variable "account_id" {
  description = "AWS account ID."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — Deployment Context
# ----------------------------------------------------------------

variable "context" {
  description = "Deployment context containing region, application name, environment, and common tags."
  type = object({
    region = string
    app    = string
    env    = string
    tags   = map(string)
  })
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — Naming Configuration
# ----------------------------------------------------------------

variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "name_suffix" {
  description = "Suffix for resource names."
  type        = string
}

variable "bucket_suffix" {
  description = "Suffix for S3 bucket names."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — Enable DB Observability Resources
# ----------------------------------------------------------------
variable "enable_db_observability" {
  description = "Enable DB-specific observability resources in this region."
  type        = bool
  default     = false
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — ALB Logging Configuration
# ----------------------------------------------------------------

variable "alb_log_s3" {
  description = "Enable ALB access logging to S3."
  type        = bool
}

variable "alb_access_logs_prefix" {
  description = "S3 key prefix for ALB access logs."
  type        = string
}

# -----------------------------------------------------------------------
# OBSERVABILITY VARIABLES — CloudWatch Metric Inputs (ALB / Target Group)
# -----------------------------------------------------------------------

variable "rds_app_public_alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics."
  type        = string
}

variable "rds_app_asg_tg_arn_suffix" {
  description = "Target group ARN suffix for CloudWatch metrics."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — WAF Logging Mode Configuration
# ----------------------------------------------------------------

variable "waf_log_mode" {
  description = "WAF logging configuration."
  type = object({
    create_direct_resources   = bool
    create_firehose_resources = bool
    target                    = string
  })
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — Logging IAM Roles
# ----------------------------------------------------------------

variable "vpc_flow_log_role_arn" {
  description = "IAM role ARN for VPC flow logs."
  type        = string
}

variable "firehose_network_telemetry_role_arn" {
  description = "IAM role ARN for Firehose network telemetry."
  type        = string
  default     = null
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — Database Monitoring Inputs
# ----------------------------------------------------------------

variable "db_identifier" {
  description = "RDS database instance identifier."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — Compute Monitoring Inputs
# ----------------------------------------------------------------

variable "rds_app_asg_name" {
  description = "Name of the RDS app Auto Scaling Group."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY VARIABLES — WAF Monitoring Inputs
# ----------------------------------------------------------------

variable "rds_app_waf_name" {
  description = "Name of the RDS app WAF web ACL."
  type        = string
  default     = null
}

variable "rds_app_waf_arn" {
  description = "ARN of the RDS app WAF web ACL."
  type        = string
}