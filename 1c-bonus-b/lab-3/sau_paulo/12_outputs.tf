#outputs
output "sau_paulo_vpc_id" {
  value = aws_vpc.sau_paulo_vpc.id
}

output "sau_paulo_public_subnet_ids" {
  value = [
    aws_subnet.sau_paulo_public_subnet_1.id,
    aws_subnet.sau_paulo_public_subnet_2.id
  ]
}

output "sau_paulo_private_subnet_ids" {
  value = [
    aws_subnet.sau_paulo_private_subnet_1.id,
    aws_subnet.sau_paulo_private_subnet_2.id
  ]
}

output "sau_paulo_nat_gateway_id" {
  value = aws_nat_gateway.sau_paulo_nat_gateway.id
}
output "sau_paulo_tgw_id" {
  value = aws_ec2_transit_gateway.sau_paulo_tgw.id
}
output "sau_paulo_tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.sau_paulo_tgw_attachment.id
}

output "sau_paulo_region" {
  value = data.aws_region.sau_paulo_region.name
}

output "sau_paulo_availability_zones" {
  value = data.aws_availability_zones.sau_paulo_azs.names
}

