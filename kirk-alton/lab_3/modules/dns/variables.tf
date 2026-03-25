# ----------------------------------------------------------------
# DNS — VARIABLES
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
# DNS — Route53 Management
# ----------------------------------------------------------------

variable "manage_route53_in_terraform" {
  description = "Manage Route53 zone and records."
  type        = bool
}

variable "route53_private_zone" {
  description = "Whether the hosted zone is private."
  type        = bool
}

variable "is_dns_writer" {
  description = "Whether this stack creates DNS records."
  type        = bool
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

# ----------------------------------------------------------------
# DNS — ALB Origin
# ----------------------------------------------------------------

variable "rds_app_public_alb_dns_name" {
  description = "ALB DNS name."
  type        = string
}

variable "rds_app_public_alb_zone_id" {
  description = "ALB hosted zone ID."
  type        = string
}