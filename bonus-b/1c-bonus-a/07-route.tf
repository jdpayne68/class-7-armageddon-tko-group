############################################
# Routing (Public + Private Route Tables)
############################################

# Explanation: Public route table = “open lanes” to the galaxy via IGW.
resource "aws_route_table" "armageddon_public_rt01" {
  vpc_id = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.armageddon_prefix}-public-rt01"
  }
}

# Explanation: This route is the Kessel Run—0.0.0.0/0 goes out the IGW.
resource "aws_route" "armageddon_public_default_route" {
  route_table_id         = aws_route_table.armageddon_public_rt01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.armageddon_igw01.id
}

# Explanation: Attach public subnets to the “public lanes.”
resource "aws_route_table_association" "armageddon_public_rta" {
  count          = length(aws_subnet.armageddon_public_subnets)
  subnet_id      = aws_subnet.armageddon_public_subnets[count.index].id
  route_table_id = aws_route_table.armageddon_public_rt01.id
}

# Explanation: Private route table = “stay hidden, but still ship supplies.”
resource "aws_route_table" "armageddon_private_rt01" {
  vpc_id = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.armageddon_prefix}-private-rt01"
  }
}

# Explanation: Private subnets route outbound internet via NAT (armageddon-approved stealth).
resource "aws_route" "armageddon_private_default_route" {
  route_table_id         = aws_route_table.armageddon_private_rt01.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.armageddon_nat01.id
}

# Explanation: Attach private subnets to the “stealth lanes.”
resource "aws_route_table_association" "armageddon_private_rta" {
  count          = length(aws_subnet.armageddon_private_subnets)
  subnet_id      = aws_subnet.armageddon_private_subnets[count.index].id
  route_table_id = aws_route_table.armageddon_private_rt01.id
}
