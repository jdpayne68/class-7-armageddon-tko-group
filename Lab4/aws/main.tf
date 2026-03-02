# Customer Gateway — represents the GCP side of the VPN
resource "aws_customer_gateway" "nihonmachi_cgw01" {
  bgp_asn    = var.gcp_bgp_asn
  ip_address = "34.157.96.145" # placeholder — will update after GCP HA VPN is created
  type       = "ipsec.1"
  tags = {
    Name = "nihonmachi-cgw01"
  }
}

# Site-to-Site VPN attached to Transit Gateway
resource "aws_vpn_connection" "nihonmachi_vpn01" {
  customer_gateway_id = aws_customer_gateway.nihonmachi_cgw01.id
  transit_gateway_id  = var.tgw_id
  type                = "ipsec.1"
  static_routes_only  = false # false = use BGP dynamic routing

  tunnel1_inside_cidr = "169.254.12.0/30"
  tunnel2_inside_cidr = "169.254.12.4/30"

  tags = {
    Name = "nihonmachi-vpn01"
  }
}
