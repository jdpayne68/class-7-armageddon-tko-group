# ----------------------------------------------------------------
# TGW CONNECTION — LOCALS
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # GLOBAL — Identity
  # ----------------------------------------------------------------

  account_id = data.aws_caller_identity.current.account_id

  # ----------------------------------------------------------------
  # IDENTITY — Normalization
  # ----------------------------------------------------------------

  normalized_app = lower(var.app)
  normalized_env = lower(var.env)

  # ----------------------------------------------------------------
  # TOPOLOGY — Peering Identity
  # ----------------------------------------------------------------

  peering_name = "${var.source_region}-${var.peer_region}"

  # ----------------------------------------------------------------
  # TAGGING — Base Tags
  # ----------------------------------------------------------------

  base_tags = {
    Region      = "multi-region"
    Application = local.normalized_app
    Environment = local.normalized_env
    Scope       = "tgw-peering"
    Topology    = local.peering_name
  }

  # ----------------------------------------------------------------
  # CONTEXT — Shared Object
  # ----------------------------------------------------------------

  context = {
    region = "multi-region"
    app    = local.normalized_app
    env    = local.normalized_env
    tags   = local.base_tags
  }

  # ----------------------------------------------------------------
  # NAMING — Derived Values
  # ----------------------------------------------------------------

  name_prefix = local.context.app
  name_suffix = local.context.env
}