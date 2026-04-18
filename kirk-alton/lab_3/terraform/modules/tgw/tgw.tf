# ----------------------------------------------------------------
# TRANSIT GATEWAY — CORE
# ----------------------------------------------------------------
# Regional Transit Gateway for inter-VPC and cross-region connectivity
# Created for each region (e.g., Tokyo hub, Sao Paulo spoke)

resource "aws_ec2_transit_gateway" "main" {
  provider = aws.regional

  description = "${var.context.region}-${var.tgw_role}-tgw-${var.context.env}"

  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = merge(
    {
      Name      = "${var.context.region}-${var.tgw_role}-tgw-${var.context.env}"
      Component = "network"
      TGWRole   = var.tgw_role
    },
    var.tgw_tags
  )
}