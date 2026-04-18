# ----------------------------------------------------------------
# NETWORK — VARIABLES
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

variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "name_suffix" {
  description = "Resource name suffix."
  type        = string
}

# ----------------------------------------------------------------
# NETWORKING — Core Inputs
# ----------------------------------------------------------------

variable "azs" {
  description = "Availability zones."
  type        = list(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

# ----------------------------------------------------------------
# MISC — Demo
# ----------------------------------------------------------------
# DEMO: Not used in deployment.

variable "demo_owner" {
  description = "Demo owner identifier."
  type        = string
}