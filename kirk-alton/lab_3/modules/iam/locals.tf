# ----------------------------------------------------------------
# IAM — LOCALS
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # GLOBAL — Identity
  # ----------------------------------------------------------------

  account_id = var.account_id

  # ----------------------------------------------------------------
  # CONTEXT — Derived Values
  # ----------------------------------------------------------------

  app    = var.context.app
  env    = var.context.env
  tags   = var.context.tags
  region = var.context.region

  # ----------------------------------------------------------------
  # NAMING — Helpers
  # ----------------------------------------------------------------

  name_prefix = "${var.context.app}-${var.context.env}"
  name_suffix = lower(var.name_suffix) # Unless normalization defines identity, transformation belongs in modules.

  #bucket_suffix = var.bucket_suffix
}