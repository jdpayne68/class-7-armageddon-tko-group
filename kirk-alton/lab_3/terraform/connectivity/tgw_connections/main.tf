# ----------------------------------------------------------------
# GLOBAL — Transit Gateway Peering (Tokyo ↔ Sao Paulo)
# ----------------------------------------------------------------

module "tgw_peering" {
  source = "../../modules/tgw_peering"

  providers = {
    aws.source = aws.tokyo
    aws.peer   = aws.saopaulo
  }

  # Identity and Naming
  context     = local.context
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # TGW Peering Parameters
  source_tgw_id = data.terraform_remote_state.tokyo.outputs.tgw_id
  peer_tgw_id   = data.terraform_remote_state.saopaulo.outputs.tgw_id

  source_route_table_id = data.terraform_remote_state.tokyo.outputs.tgw_route_table_id
  peer_route_table_id   = data.terraform_remote_state.saopaulo.outputs.tgw_route_table_id

  source_vpc_cidr = data.terraform_remote_state.tokyo.outputs.vpc_cidr
  peer_vpc_cidr   = data.terraform_remote_state.saopaulo.outputs.vpc_cidr

  peer_region  = data.terraform_remote_state.saopaulo.outputs.application_context.region
  peering_name = local.peering_name
}