############################################
# NAT Gateway
############################################

# Explanation: armageddon wants the private base to call home—EIP gives the NAT a stable “holonet address.”
resource "aws_nat_gateway" "armageddon_nat01" {
  allocation_id = aws_eip.armageddon_nat_eip01.id
  subnet_id     = aws_subnet.armageddon_public_subnets[0].id # NAT in a public subnet

  tags = {
    Name = "${local.armageddon_prefix}-nat01"
  }

  depends_on = [aws_internet_gateway.armageddon_igw01]
}
