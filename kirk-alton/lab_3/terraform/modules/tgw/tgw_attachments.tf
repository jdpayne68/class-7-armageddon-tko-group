# ----------------------------------------------------------------
# TRANSIT GATEWAY — VPC ATTACHMENT
# ----------------------------------------------------------------
# Attaches private application subnets to the Transit Gateway
# Used for inter-VPC and cross-region compute communication

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachment" {
  provider = aws.regional

  transit_gateway_id = aws_ec2_transit_gateway.main.id

  vpc_id     = var.vpc_id
  subnet_ids = var.private_app_subnet_ids

  tags = merge(
    {
      Name      = "${var.context.region}-tgw-attachment-${var.context.env}"
      Component = "network"
    },
    var.tgw_tags
  )
}