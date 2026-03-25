# # ----------------------------------------------------------------
# # TOKYO TRANSIT GATEWAY
# # ----------------------------------------------------------------


# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — TOKYO (HUB)
# # ----------------------------------------------------------------
# # Core TGW. Regional hub for inter-VPC communication

# resource "aws_ec2_transit_gateway" "tokyo" {
#   description = "${local.name_prefix}-tokyo-hub-tgw"

#   auto_accept_shared_attachments  = "disable"
#   default_route_table_association = "disable"
#   default_route_table_propagation = "disable"

#   tags = merge(
#     {
#       Name      = "${local.name_prefix}-tokyo-hub-tgw"
#       Component = "network"
#       Role      = "hub"
#     },
#     local.context.tags
#   )
# }

# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — VPC ATTACHMENT (TOKYO)
# # ----------------------------------------------------------------
# # Attaches Tokyo VPC private subnets to TGW

# resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo" {
#   transit_gateway_id = aws_ec2_transit_gateway.tokyo.id

#   vpc_id     = module.network.vpc_id
#   subnet_ids = module.network.private_app_subnet_ids

#   tags = merge(
#     {
#       Name      = "${local.name_prefix}-tokyo-tgw-attachment"
#       Component = "network"
#     },
#     local.context.tags
#   )
# }

# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — ROUTE TABLE (TOKYO)
# # ----------------------------------------------------------------
# # Dedicated TGW route table for Tokyo hub routing 

# resource "aws_ec2_transit_gateway_route_table" "tokyo" {
#   transit_gateway_id = aws_ec2_transit_gateway.tokyo.id

#   tags = merge(
#     {
#       Name      = "${local.name_prefix}-tokyo-tgw-rt"
#       Component = "network"
#     },
#     local.context.tags
#   )
# }

# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — ROUTE TABLE ASSOCIATION (TOKYO)
# # ----------------------------------------------------------------
# # Associates VPC attachment with TGW route table

# resource "aws_ec2_transit_gateway_route_table_association" "tokyo" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tokyo.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
# }















# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — PEERING (TOKYO → SAO PAULO)
# # ----------------------------------------------------------------
# # Initiates cross-region TGW peering connection
# # !! PHASE 2: Requires Sao Paulo TGW to exist

# resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_to_saopaulo" {
#   transit_gateway_id      = aws_ec2_transit_gateway.tokyo.id
#   peer_transit_gateway_id = var.saopaulo_tgw_id
#   peer_region             = "sa-east-1"
# }

# # ----------------------------------------------------------------
# # TRANSIT GATEWAY — ROUTE (TOKYO → SAO PAULO)
# # ----------------------------------------------------------------
# # Routes traffic destined for Sao Paulo VPC via TGW peering
# # !! PHASE 2: Depends on peering attachment

# resource "aws_ec2_transit_gateway_route" "tokyo_to_saopaulo" {
#   destination_cidr_block         = var.saopaulo_vpc_cidr # FIXME: consider renaming to remote_vpc_cidr
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.id
# }