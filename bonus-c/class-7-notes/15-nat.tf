############################################
# NAT Gateway + EIP
############################################

resource "aws_eip" "armageddon_nat_eip01" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip01"
  }
}

# Explanation: NAT is armageddon’s smuggler tunnel—private subnets can reach out without being seen.
resource "aws_nat_gateway" "armageddon_nat01" {
  allocation_id = aws_eip.armageddon_nat_eip01.id
  subnet_id     = aws_subnet.armageddon_public_subnets[0].id # NAT in a public subnet

  tags = {
    Name = "${local.name_prefix}-nat01"
  }

  depends_on = [aws_internet_gateway.armageddon_igw01]
}
