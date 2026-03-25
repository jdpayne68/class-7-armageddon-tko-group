# ----------------------------------------------------------------
# TRANSIT GATEWAY — VARIABLES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# GLOBAL — Identity
# ----------------------------------------------------------------

variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "name_suffix" {
  description = "Resource name suffix."
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

variable "tgw_role" {
  description = "Transit Gateway role (hub or spoke)."
  type        = string
}

# ----------------------------------------------------------------
# NETWORKING — VPC Attachment
# ----------------------------------------------------------------

variable "vpc_id" {
  description = "VPC ID for attachment."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private subnet IDs for TGW attachment."
  type        = list(string)
}

# Use only if EC2 are in fully private subnet and need cross-region connectivity.
# variable "private_data_subnet_ids" {
#   description = "Private data subnet IDs."
#   type        = list(string)
# }

# ----------------------------------------------------------------
# TAGGING — Transit Gateway
# ----------------------------------------------------------------

variable "tgw_tags" {
  description = "Tags for Transit Gateway."
  type        = map(string)
  default     = {}
}