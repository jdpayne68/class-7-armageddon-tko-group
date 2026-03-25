# ----------------------------------------------------------------
# NETWORKING — Public Route Table Associations
# ----------------------------------------------------------------
resource "aws_route_table_association" "public_a" {
  provider = aws.regional

  subnet_id      = local.public_subnet_ids[0]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  provider = aws.regional

  subnet_id      = local.public_subnet_ids[1]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  provider = aws.regional

  subnet_id      = local.public_subnet_ids[2]
  route_table_id = aws_route_table.public.id
}

# ----------------------------------------------------------------
# NETWORKING — Private App Subnet Route Associations
# ----------------------------------------------------------------
resource "aws_route_table_association" "private_app_a" {
  provider = aws.regional

  subnet_id      = local.private_app_subnet_ids[0]
  route_table_id = aws_route_table.local.id
}

resource "aws_route_table_association" "private_app_b" {
  provider = aws.regional

  subnet_id      = local.private_app_subnet_ids[1]
  route_table_id = aws_route_table.local.id
}

resource "aws_route_table_association" "private_app_c" {
  provider = aws.regional

  subnet_id      = local.private_app_subnet_ids[2]
  route_table_id = aws_route_table.local.id
}

# ----------------------------------------------------------------
# NETWORKING — Private Data Subnet Route Associations
# ----------------------------------------------------------------
resource "aws_route_table_association" "private_data_a" {
  provider = aws.regional

  subnet_id      = local.private_data_subnet_ids[0]
  route_table_id = aws_route_table.local.id
}

resource "aws_route_table_association" "private_data_b" {
  provider = aws.regional

  subnet_id      = local.private_data_subnet_ids[1]
  route_table_id = aws_route_table.local.id
}

resource "aws_route_table_association" "private_data_c" {
  provider = aws.regional

  subnet_id      = local.private_data_subnet_ids[2]
  route_table_id = aws_route_table.local.id
}