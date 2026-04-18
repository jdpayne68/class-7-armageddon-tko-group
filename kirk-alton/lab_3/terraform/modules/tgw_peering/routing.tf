# ----------------------------------------------------------------
# TGW PEERING — Routing (Source → Peer)
# ----------------------------------------------------------------

resource "aws_ec2_transit_gateway_route" "route_to_peer" {
  provider = aws.source

  destination_cidr_block         = var.peer_vpc_cidr
  transit_gateway_route_table_id = var.source_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peering_request.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accept
  ]
}

# ----------------------------------------------------------------
# TGW PEERING — Routing (Peer → Source)
# ----------------------------------------------------------------

resource "aws_ec2_transit_gateway_route" "route_to_source" {
  provider = aws.peer

  destination_cidr_block         = var.source_vpc_cidr
  transit_gateway_route_table_id = var.peer_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peering_request.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accept
  ]
}