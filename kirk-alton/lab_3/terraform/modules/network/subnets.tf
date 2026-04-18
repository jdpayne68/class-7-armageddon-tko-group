# ----------------------------------------------------------------
# NETWORKING — Subnets (Public)
# ----------------------------------------------------------------

# Public Subnet Configuration
resource "aws_subnet" "public_a" {
  provider = aws.regional

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name      = "public-a"
      Component = "network"
    },
    var.context.tags,
    local.public_subnet_tags
  )
}

# azs = data.aws_availability_zones.available.names

resource "aws_subnet" "public_b" {
  provider = aws.regional

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name      = "public-b"
      Component = "network"
    },
    var.context.tags,
    local.public_subnet_tags
  )
}

resource "aws_subnet" "public_c" {
  provider = aws.regional

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.3.0/24"
  availability_zone       = var.azs[2]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name      = "public-c"
      Component = "network"
    },
    var.context.tags,
    local.public_subnet_tags
  )
}

# ----------------------------------------------------------------
# NETWORKING — Subnets (Private Application)
# ----------------------------------------------------------------

# Private App Subnet Configuration
resource "aws_subnet" "private_app_a" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.11.0/24"
  availability_zone = var.azs[0]

  tags = merge(
    {
      Name      = "private-app-a"
      Component = "network"
    },
    var.context.tags,
    local.private_app_subnet_tags
  )
}

resource "aws_subnet" "private_app_b" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.22.0/24"
  availability_zone = var.azs[1]

  tags = merge(
    {
      Name      = "private-app-b"
      Component = "network"
    },
    var.context.tags,
    local.private_app_subnet_tags
  )
}

resource "aws_subnet" "private_app_c" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.33.0/24"
  availability_zone = var.azs[2]

  tags = merge(
    {
      Name      = "private-app-c"
      Component = "network"
    },
    var.context.tags,
    local.private_app_subnet_tags
  )
}

# ----------------------------------------------------------------
# NETWORKING — Subnets (Private Data)
# ----------------------------------------------------------------

# Private Data Subnet Configuration
resource "aws_subnet" "private_data_a" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.44.0/24"
  availability_zone = var.azs[0]

  tags = merge(
    {
      Name      = "private-data-a"
      Component = "network"
    },
    var.context.tags,
    local.private_data_subnet_tags
  )
}

resource "aws_subnet" "private_data_b" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.55.0/24"
  availability_zone = var.azs[1]

  tags = merge(
    {
      Name      = "private-data-b"
      Component = "network"
    },
    var.context.tags,
    local.private_data_subnet_tags
  )
}

resource "aws_subnet" "private_data_c" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.66.0/24"
  availability_zone = var.azs[2]

  tags = merge(
    {
      Name      = "private-data-c"
      Component = "network"
    },
    var.context.tags,
    local.private_data_subnet_tags
  )
}