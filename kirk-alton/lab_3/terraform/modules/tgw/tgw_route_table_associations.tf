# ----------------------------------------------------------------
# TRANSIT GATEWAY — ROUTE TABLE ASSOCIATION
# ----------------------------------------------------------------
# Associates the VPC attachment with the TGW route table

resource "aws_ec2_transit_gateway_route_table_association" "vpc_assoc" {
  provider = aws.regional

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main_rt.id
}