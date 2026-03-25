# ----------------------------------------------------------------
# TGW CONNECTION — VARIABLES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# GLOBAL — Identity
# ----------------------------------------------------------------

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
# TOPOLOGY — Regions
# ----------------------------------------------------------------

variable "source_region" {
  description = "Source region (e.g., ap-northeast-1)."
  type        = string
  default     = "ap-northeast-1"
}

variable "peer_region" {
  description = "Peer region (e.g., sa-east-1)."
  type        = string
  default     = "sa-east-1"
}