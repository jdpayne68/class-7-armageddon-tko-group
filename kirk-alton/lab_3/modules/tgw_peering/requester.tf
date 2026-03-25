# ----------------------------------------------------------------
# TGW PEERING — Request (Source → Peer)
# ----------------------------------------------------------------

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering_request" {
  provider = aws.source

  transit_gateway_id      = var.source_tgw_id
  peer_transit_gateway_id = var.peer_tgw_id
  peer_region             = var.peer_region

  tags = merge(var.context.tags, {
    Name = "${var.name_prefix}-${var.peering_name}-tgw-peering-${var.name_suffix}"
  })
}