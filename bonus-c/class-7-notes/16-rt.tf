############################################
# Routing (Public + Private Route Tables)
############################################

resource "aws_route_table" "armageddon_public_rt01" {
  vpc_id = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.name_prefix}-public-rt01"
  }
}

resource "aws_route" "armageddon_public_default_route" {
  route_table_id         = aws_route_table.armageddon_public_rt01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.armageddon_igw01.id
}

resource "aws_route_table_association" "armageddon_public_rta" {
  count          = length(aws_subnet.armageddon_public_subnets)
  subnet_id      = aws_subnet.armageddon_public_subnets[count.index].id
  route_table_id = aws_route_table.armageddon_public_rt01.id
}

resource "aws_route_table" "armageddon_private_rt01" {
  vpc_id = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.name_prefix}-private-rt01"
  }
}

resource "aws_route" "armageddon_private_default_route" {
  route_table_id         = aws_route_table.armageddon_private_rt01.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.armageddon_nat01.id
}

resource "aws_route_table_association" "armageddon_private_rta" {
  count          = length(aws_subnet.armageddon_private_subnets)
  subnet_id      = aws_subnet.armageddon_private_subnets[count.index].id
  route_table_id = aws_route_table.armageddon_private_rt01.id
}

