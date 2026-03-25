# ----------------------------------------------------------------
# TGW PEERING — Accepter (Peer Region)
# ----------------------------------------------------------------

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering_accept" {
  provider = aws.peer

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering_request.id

  tags = merge(var.context.tags, {
    Name = "${var.name_prefix}-${var.peering_name}-tgw-peering-accept-${var.name_suffix}"
  })
}