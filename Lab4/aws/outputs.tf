output "tunnel1_outside_ip" {
  value = aws_vpn_connection.nihonmachi_vpn01.tunnel1_address
}

output "tunnel2_outside_ip" {
  value = aws_vpn_connection.nihonmachi_vpn01.tunnel2_address
}

output "tunnel1_psk" {
  value     = aws_vpn_connection.nihonmachi_vpn01.tunnel1_preshared_key
  sensitive = true
}

output "tunnel2_psk" {
  value     = aws_vpn_connection.nihonmachi_vpn01.tunnel2_preshared_key
  sensitive = true
}

output "aws_bgp_asn" {
  value = aws_vpn_connection.nihonmachi_vpn01.tunnel1_bgp_asn
}
