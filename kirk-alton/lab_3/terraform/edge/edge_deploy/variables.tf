# ----------------------------------------------------------------
# EDGE DEPLOY VARIABLES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# GLOBAL — Identity
# ----------------------------------------------------------------

variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
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
# NETWORKING — N/A (edge has no VPC)
# ----------------------------------------------------------------

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
# COMPUTE — N/A (no regional compute)
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# DATABASE — N/A (no stateful services)
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OBSERVABILITY — Reserved (WAF / edge logging)
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# LOAD BALANCING — Reserved (CloudFront)
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# CONNECTIVITY — N/A (no TGW)
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# MISC — Reserved
# ----------------------------------------------------------------