# Explanation: Shinjuku returns traffic to Liberdade—because doctors need answers, not one-way tunnels.
resource "aws_route" "shinjuku_to_sp_route01" {
  route_table_id         = aws_route_table.chewbacca_private_rt01.id
  destination_cidr_block = "10.2.0.0/16" # Sao Paulo VPC CIDR (students supply)
  transit_gateway_id     = aws_ec2_transit_gateway.shinjuku_tgw01.id
}

# TGW route: tell Tokyo TGW to send São Paulo traffic across the peering
resource "aws_ec2_transit_gateway_route" "shinjuku_tgw_to_sp01" {
  destination_cidr_block         = "10.2.0.0/16"
  transit_gateway_attachment_id  = "tgw-attach-0190087957dfc1d03"  # Peering attachment
  transit_gateway_route_table_id = "tgw-rtb-08fe028e2af07d22d"    # Tokyo TGW route table
}