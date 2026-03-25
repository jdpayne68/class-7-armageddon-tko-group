# ----------------------------------------------------------------
# EDGE — VARIABLES
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
# SECURITY — Edge Authentication
# ----------------------------------------------------------------

variable "edge_auth_header_name" {
  description = "Header name for edge-to-origin auth."
  type        = string
}

variable "edge_auth_value" {
  description = "Header value for CloudFront → ALB auth."
  type        = string
  sensitive   = true
}