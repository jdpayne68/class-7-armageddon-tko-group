# ----------------------------------------------------------------
# EDGE DEPLOY MAIN — MODULES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# EDGE
# ----------------------------------------------------------------

module "edge" {
  source = "../../modules/edge"

  providers = { aws.edge = aws.edge }

  # Identity and Naming
  context     = local.context
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # DNS Context
  dns_context = local.dns_context
  zone_id     = module.dns.zone_id

  # Edge Security
  edge_auth_header_name = local.edge_auth_header_name
  edge_auth_value       = data.terraform_remote_state.tokyo.outputs.edge_auth_value
}

# ----------------------------------------------------------------
# MODULE — DNS
# ----------------------------------------------------------------

module "dns" {
  source = "../../modules/dns"

  # Providers
  providers = { aws.regional = aws.edge }

  # Identity and Naming
  context     = local.context
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # DNS Context
  dns_context = local.dns_context

  # Route53 Management
  manage_route53_in_terraform = var.manage_route53_in_terraform
  route53_private_zone        = var.route53_private_zone
  is_dns_writer               = var.is_dns_writer

  # Regional Origin (Tokyo ALB)
  rds_app_public_alb_dns_name = data.terraform_remote_state.tokyo.outputs.rds_app_public_alb_dns_name
  rds_app_public_alb_zone_id  = data.terraform_remote_state.tokyo.outputs.rds_app_public_alb_zone_id
}