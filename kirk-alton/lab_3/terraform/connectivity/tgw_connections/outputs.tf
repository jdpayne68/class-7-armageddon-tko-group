# ----------------------------------------------------------------
# TGW CONNECTION — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# CONTEXT — Identity
# ----------------------------------------------------------------

output "connection_context" {
  description = "TGW connection context."

  value = {
    application = local.context.app
    environment = local.context.env
    topology    = local.peering_name
    region      = local.context.region
  }
}

# ----------------------------------------------------------------
# TOPOLOGY — Regions
# ----------------------------------------------------------------

output "regions" {
  description = "Regions participating in the TGW connection."

  value = {
    source = var.source_region
    peer   = var.peer_region
  }
}

# ----------------------------------------------------------------
# NAMING — Connection Identity
# ----------------------------------------------------------------

output "peering_name" {
  description = "Logical name of the TGW connection."
  value       = local.peering_name
}