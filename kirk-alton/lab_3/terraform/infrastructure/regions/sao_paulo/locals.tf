# ----------------------------------------------------------------
# SAO PAULO — LOCALS
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # GLOBAL — Identity & Region
  # ----------------------------------------------------------------

  account_id = data.aws_caller_identity.current.account_id
  azs        = slice(data.aws_availability_zones.available.names, 0, 3)

  # ----------------------------------------------------------------
  # IDENTITY — Normalization
  # ----------------------------------------------------------------

  normalized_app = lower(var.app)
  normalized_env = lower(var.env)

  # ----------------------------------------------------------------
  # TAGGING — Base Tags
  # ----------------------------------------------------------------

  base_tags = {
    Region      = var.region
    Application = local.normalized_app
    Environment = local.normalized_env
  }

  # ----------------------------------------------------------------
  # CONTEXT — Shared Object
  # ----------------------------------------------------------------

  context = {
    region = var.region
    app    = local.normalized_app
    env    = local.normalized_env
    tags   = local.base_tags
  }

  # ----------------------------------------------------------------
  # NAMING — Derived Values
  # ----------------------------------------------------------------

  name_prefix   = "${local.context.app}-${local.context.env}"
  name_suffix   = lower(random_string.suffix.result)
  bucket_suffix = lower(random_id.bucket_suffix.hex)

  # ----------------------------------------------------------------
  # DNS — Context
  # ----------------------------------------------------------------

  dns_context = {
    root_domain   = var.root_domain
    app_subdomain = local.normalized_app
    fqdn          = "${local.normalized_app}.${var.root_domain}"
  }

  # ----------------------------------------------------------------
  # SECURITY — Edge Auth
  # ----------------------------------------------------------------

  edge_auth_header_name = "X-${local.name_prefix}-edge-auth-v1"

  # ----------------------------------------------------------------
  # OBSERVABILITY — WAF Logging Mode
  # ----------------------------------------------------------------

  waf_log_mode_map = {
    cloudwatch = {
      create_direct_resources   = true
      create_firehose_resources = false
      target                    = "cloudwatch"
    }

    firehose = {
      create_direct_resources   = false
      create_firehose_resources = true
      target                    = "firehose"
    }

    s3 = {
      create_direct_resources   = true
      create_firehose_resources = false
      target                    = "s3"
    }
  }

  waf_log_mode = local.waf_log_mode_map[var.waf_log_destination]

  # ----------------------------------------------------------------
  # VALIDATION — Safety Check
  # ----------------------------------------------------------------

  waf_log_mode_valid = (
    (local.waf_log_mode.create_direct_resources && !local.waf_log_mode.create_firehose_resources) ||
    (!local.waf_log_mode.create_direct_resources && local.waf_log_mode.create_firehose_resources)
  )
}