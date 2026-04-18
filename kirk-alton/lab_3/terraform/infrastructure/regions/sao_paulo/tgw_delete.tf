# # ----------------------------------------------------------------
# # SAO PAULO TRANSIT GATEWAY
# # ----------------------------------------------------------------


# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — SAO PAULO (SPOKE)
# # ----------------------------------------------------------------
# # Core TGW. Regional spoke for inter-VPC communication

# resource "aws_ec2_transit_gateway" "saopaulo" {
#   description = "${local.name_prefix}-saopaulo-spoke-tgw"

#   auto_accept_shared_attachments  = "disable"
#   default_route_table_association = "disable"
#   default_route_table_propagation = "disable"

#   tags = merge(
#     {
#       Name      = "${local.name_prefix}-saopaulo-spoke-tgw"
#       Component = "network"
#       Role      = "spoke"
#     },
#     local.context.tags
#   )
# }

# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — VPC ATTACHMENT (SAO PAULO)
# # ----------------------------------------------------------------
# # Attaches Sao Paulo VPC private subnets to TGW

# resource "aws_ec2_transit_gateway_vpc_attachment" "saopaulo" {
#   transit_gateway_id = aws_ec2_transit_gateway.saopaulo.id

#   vpc_id     = module.network.vpc_id
#   subnet_ids = module.network.private_app_subnet_ids

#   tags = merge(
#     {
#       Name      = "${local.name_prefix}-saopaulo-tgw-attachment"
#       Component = "network"
#     },
#     local.context.tags
#   )
# }

# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — ROUTE TABLE (SAO PAULO)
# # ----------------------------------------------------------------
# # Dedicated TGW route table for spoke routing

# resource "aws_ec2_transit_gateway_route_table" "saopaulo" {
#   transit_gateway_id = aws_ec2_transit_gateway.saopaulo.id

#   tags = merge(
#     {
#       Name      = "${local.name_prefix}-saopaulo-tgw-rt"
#       Component = "network"
#     },
#     local.context.tags
#   )
# }

# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — ROUTE TABLE ASSOCIATION (SAO PAULO)
# # ----------------------------------------------------------------
# # Associates VPC attachment with TGW route table

# resource "aws_ec2_transit_gateway_route_table_association" "saopaulo" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.saopaulo.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.saopaulo.id
# }

# # # ----------------------------------------------------------------
# # # TRANSIT GATEWAY — PEERING ACCEPTOR (SAO PAULO)
# # # ----------------------------------------------------------------
# # # Accepts TGW peering from Tokyo hub
# # # !! PHASE 2: Requires Tokyo peering attachment to exist

# # resource "aws_ec2_transit_gateway_peering_attachment_accepter" "from_tokyo" {
# #   transit_gateway_attachment_id = data.terraform_remote_state.tokyo.outputs.tgw_peering_attachment_id

# #   tags = merge(
# #     {
# #       Name      = "${local.name_prefix}-saopaulo-accepts-tokyo-peering"
# #       Component = "network"
# #     },
# #     local.context.tags
# #   )
# # }

# # # ----------------------------------------------------------------
# # # TRANSIT GATEWAY — ROUTE (SAO PAULO → TOKYO)
# # # ----------------------------------------------------------------
# # # Routes traffic destined for Tokyo VPC via TGW peering
# # # !! PHASE 2: Depends on peering acceptance

# # resource "aws_ec2_transit_gateway_route" "saopaulo_to_tokyo" {
# #   destination_cidr_block         = var.tokyo_vpc_cidr # FIXME: consider renaming to remote_vpc_cidr
# #   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.saopaulo.id
# #   transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.from_tokyo.id
# # }