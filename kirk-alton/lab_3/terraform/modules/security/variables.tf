# ----------------------------------------------------------------
# SECURITY — VARIABLES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# FEATURE FLAGS — WAF
# ----------------------------------------------------------------

variable "create_waf" {
  description = "Create CloudFront WAF Web ACL."
  type        = bool
  default     = false
}

# ----------------------------------------------------------------
# GLOBAL — Identity & Networking
# ----------------------------------------------------------------

variable "account_id" {
  description = "AWS account ID."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
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
# LOGGING — WAF Configuration
# ----------------------------------------------------------------

variable "waf_log_retention_days" {
  description = "WAF log retention (days)."
  type        = number
}

variable "enable_waf_sampled_requests_only" {
  description = "Enable sampled request visibility."
  type        = bool
}

variable "enable_direct_service_log_delivery" {
  description = "Enable direct service log delivery."
  type        = bool
}

# ----------------------------------------------------------------
# LOGGING — WAF Mode
# ----------------------------------------------------------------

variable "waf_log_mode" {
  description = "WAF logging configuration."
  type = object({
    create_direct_resources   = bool
    create_firehose_resources = bool
    target                    = string
  })
}

variable "waf_log_destination_arn" {
  description = "WAF log destination ARN."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY — WAF Log Bucket
# ----------------------------------------------------------------

variable "waf_log_bucket_arn" {
  description = "S3 bucket ARN for WAF logs."
  type        = string
}

variable "waf_log_bucket_id" {
  description = "S3 bucket ID for WAF logs."
  type        = string
}