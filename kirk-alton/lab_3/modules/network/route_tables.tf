# ----------------------------------------------------------------
# NETWORKING — Route Tables (Public)
# ----------------------------------------------------------------

# Public Route Table
resource "aws_route_table" "public" {
  provider = aws.regional

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    {
      Name      = "${var.name_prefix}-public-rt"
      Component = "network"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# NETWORKING — Route Tables (Private / Local)
# ----------------------------------------------------------------

# Local Route Table
resource "aws_route_table" "local" {
  provider = aws.regional

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = merge(
    {
      Name      = "${var.name_prefix}-local-rt"
      Component = "network"
    },
    var.context.tags
  )
}

# # ----------------------------------------------------------------
# # NETWORKING — Route Tables (Tokyo to Saopaulo Transit Gateway)
# # ----------------------------------------------------------------

# resource "aws_route" "to_saopaulo" {
#   route_table_id         = aws_route_table.local.id
#   destination_cidr_block = var.vpc_cidr
#   transit_gateway_id     = var.tgw_id
# }