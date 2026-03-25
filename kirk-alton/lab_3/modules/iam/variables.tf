# ----------------------------------------------------------------
# IAM — VARIABLES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# GLOBAL — Identity
# ----------------------------------------------------------------

variable "account_id" {
  description = "AWS account ID."
  type        = string
}

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
# SECURITY — Secrets & Database
# ----------------------------------------------------------------

variable "db_secret_arn" {
  description = "Secrets Manager ARN for DB credentials."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY — Logging & Delivery
# ----------------------------------------------------------------

variable "enable_direct_service_log_delivery" {
  description = "Enable direct service log delivery to CloudWatch."
  type        = bool
}

# ----------------------------------------------------------------
# OBSERVABILITY — Log Destinations
# ----------------------------------------------------------------

variable "vpc_flow_log_group_arn" {
  description = "CloudWatch log group ARN for VPC flow logs."
  type        = string
}

variable "waf_firehose_log_group_arn" {
  description = "CloudWatch log group ARN for WAF Firehose."
  type        = string
}

variable "waf_firehose_log_bucket_arn" {
  description = "S3 bucket ARN for WAF Firehose logs."
  type        = string
}

variable "waf_direct_log_group_arn" {
  description = "CloudWatch log group ARN for direct WAF logs."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY — WAF Logging Mode
# ----------------------------------------------------------------

variable "waf_log_mode" {
  description = "WAF logging configuration."
  type = object({
    create_direct_resources   = bool
    create_firehose_resources = bool
    target                    = string
  })
}