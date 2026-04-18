# ----------------------------------------------------------------
# TRANSIT GATEWAY — ROUTE TABLE
# ----------------------------------------------------------------
# TGW route table for controlling traffic between attachments

resource "aws_ec2_transit_gateway_route_table" "main_rt" {
  provider = aws.regional

  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = merge(
    {
      Name      = "${var.context.region}-tgw-rt-${var.context.env}"
      Component = "network"
    },
    var.tgw_tags
  )
}