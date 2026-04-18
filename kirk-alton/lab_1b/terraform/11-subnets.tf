# Public Subnet Configuration
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = local.azs[0]
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "public-a"
    },
    local.public_subnet_tags
  )
}
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = local.azs[1]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "public-b"
    },
    local.public_subnet_tags
  )
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.3.0/24"
  availability_zone = local.azs[2]

  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "public-c"
    },
    local.public_subnet_tags
  )
}

# Private Egress Subnet Configuration
resource "aws_subnet" "private_egress_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.11.0/24"
  availability_zone = local.azs[0]

  tags = merge(
    {
      Name = "private-egress-a"
    },
    local.private_egress_subnet_tags
  )
}

resource "aws_subnet" "private_egress_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.22.0/24"
  availability_zone = local.azs[1]


  tags = merge(
    {
      Name = "private-egress-b"
    },
    local.private_egress_subnet_tags
  )
}
resource "aws_subnet" "private_egress_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.33.0/24"
  availability_zone = local.azs[2]


  tags = merge(
    {
      Name = "private-egress-c"
    },
    local.private_egress_subnet_tags
  )
}

# Private Data Subnet Configuration
resource "aws_subnet" "private_data_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.44.0/24"
  availability_zone = local.azs[0]


  tags = merge(
    {
      Name = "private-data-a"
    },
    local.private_data_subnet_tags
  )
}

resource "aws_subnet" "private_data_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.55.0/24"
  availability_zone = local.azs[1]

  tags = merge(
    {
      Name = "private-data-b"
    },
    local.private_data_subnet_tags
  )
}

resource "aws_subnet" "private_data_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.66.0/24"
  availability_zone = local.azs[2]
  tags = merge(
    {
      Name = "private-data-c"
    },
    local.private_data_subnet_tags
  )
}