# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name      = "public-route-table"
    Component = "network"
  }

}

# Public Route Table Associations
resource "aws_route_table_association" "public_a" {
  subnet_id      = local.public_subnets[0]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = local.public_subnets[1]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = local.public_subnets[2]
  route_table_id = aws_route_table.public.id
}


# Local Route Table
resource "aws_route_table" "local" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name      = "local-route-table"
    Component = "network"
  }

}


# Local Route Table Associations
# S3 VPC Endpoint Route Table Associations
resource "aws_vpc_endpoint_route_table_association" "s3_private_app_a" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.local.id
}

# Private App Subnets
resource "aws_route_table_association" "private_app_a" {
  subnet_id      = aws_subnet.private_app_a.id
  route_table_id = aws_route_table.local.id
}

resource "aws_route_table_association" "private_app_b" {
  subnet_id      = aws_subnet.private_app_b.id
  route_table_id = aws_route_table.local.id
}

resource "aws_route_table_association" "private_app_c" {
  subnet_id      = aws_subnet.private_app_c.id
  route_table_id = aws_route_table.local.id
}


# Private Data Subnets
resource "aws_route_table_association" "private_data_a" {
  subnet_id      = aws_subnet.private_data_a.id
  route_table_id = aws_route_table.local.id
}

resource "aws_route_table_association" "private_data_b" {
  subnet_id      = aws_subnet.private_data_b.id
  route_table_id = aws_route_table.local.id
}

resource "aws_route_table_association" "private_data_c" {
  subnet_id      = aws_subnet.private_data_c.id
  route_table_id = aws_route_table.local.id
}