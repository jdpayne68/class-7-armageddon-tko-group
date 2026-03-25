# ----------------------------------------------------------------
# DATABASE — VARIABLES
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

variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "name_suffix" {
  description = "Resource name suffix."
  type        = string
}

# ----------------------------------------------------------------
# NETWORKING — Subnets
# ----------------------------------------------------------------

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs."
  type        = list(string)
}

variable "private_data_subnet_ids" {
  description = "Private data subnet IDs."
  type        = list(string)
}

variable "private_app_subnet_tags" {
  description = "Tags for private app subnets."
  type        = map(string)
}

variable "private_data_subnet_tags" {
  description = "Tags for private data subnets."
  type        = map(string)
}

# ----------------------------------------------------------------
# SECURITY — Security Groups
# ----------------------------------------------------------------

variable "private_db_sg_id" {
  description = "Security group for the database."
  type        = string
}

# ----------------------------------------------------------------
# DATABASE — Configuration
# ----------------------------------------------------------------

variable "db_engine" {
  description = "Database engine."
  type        = string
}

variable "db_username" {
  description = "Database admin username."
  type        = string
}

variable "db_secret_arn" {
  description = "Secrets Manager ARN for DB credentials."
  type        = string
}

# ----------------------------------------------------------------
# OBSERVABILITY — Monitoring & Alerts
# ----------------------------------------------------------------

variable "rds_enhanced_monitoring_role_arn" {
  description = "IAM role ARN for RDS monitoring."
  type        = string
}

variable "rds_failure_alert_topic_arn" {
  description = "SNS topic ARN for RDS alerts."
  type        = string
}