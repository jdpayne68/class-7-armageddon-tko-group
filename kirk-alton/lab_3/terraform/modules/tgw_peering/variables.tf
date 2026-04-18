# ----------------------------------------------------------------
# TRANSIT GATEWAY PEERING — VARIABLES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# NAMING — Resource Naming
# ----------------------------------------------------------------

variable "peering_name" {
  description = "Logical name for TGW peering."
  type        = string
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
# GLOBAL — Context
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

# ----------------------------------------------------------------
# TOPOLOGY — Transit Gateways
# ----------------------------------------------------------------

variable "source_tgw_id" {
  description = "Source TGW ID."
  type        = string
}

variable "peer_tgw_id" {
  description = "Peer TGW ID."
  type        = string
}

variable "peer_region" {
  description = "Peer AWS region."
  type        = string
}

# ----------------------------------------------------------------
# ROUTING — TGW Route Tables
# ----------------------------------------------------------------

variable "source_route_table_id" {
  description = "Source TGW route table ID."
  type        = string
}

variable "peer_route_table_id" {
  description = "Peer TGW route table ID."
  type        = string
}

# ----------------------------------------------------------------
# ROUTING — VPC CIDRs
# ----------------------------------------------------------------

variable "source_vpc_cidr" {
  description = "Source VPC CIDR."
  type        = string
}

variable "peer_vpc_cidr" {
  description = "Peer VPC CIDR."
  type        = string
}