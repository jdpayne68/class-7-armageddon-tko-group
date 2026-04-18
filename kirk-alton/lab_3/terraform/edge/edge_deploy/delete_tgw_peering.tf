# # ----------------------------------------------------------------
# # EDGE DEPLOY TRANSIT GATEWAY PEERING — TOKYO → SAO PAULO)
# # ----------------------------------------------------------------
# # Initiates cross-region TGW peering

# resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_to_saopaulo" {
#     provider = aws.tokyo
#   transit_gateway_id      = data.terraform_remote_state.tokyo.outputs.tgw_id
#   peer_transit_gateway_id = data.terraform_remote_state.saopaulo.outputs.tgw_id
#   peer_region             = "sa-east-1"

#   tags = {
#     Name = "tokyo-to-saopaulo-tgw-peering"
#   }
# }

# # ----------------------------------------------------------------
# # EDGE DEPLOY TRANSIT GATEWAY PEERING — ACCEPTOR (SAO PAULO)
# # ----------------------------------------------------------------

# resource "aws_ec2_transit_gateway_peering_attachment_accepter" "saopaulo_accept" {
#     provider = aws.saopaulo
#   transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.id

#   tags = {
#     Name = "saopaulo-accept-tgw-peering"
#   }
# }