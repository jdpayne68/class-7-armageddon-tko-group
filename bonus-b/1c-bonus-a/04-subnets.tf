############################################
# Subnets (Public + Private)
############################################

# Explanation: Public subnets are like docking bays—ships can land directly from space (internet).
resource "aws_subnet" "armageddon_public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.armageddon_vpc01.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.armageddon_prefix}-public-subnet0${count.index + 1}"
  }
}

# Explanation: Private subnets are the hidden Rebel base—no direct access from the internet.
resource "aws_subnet" "armageddon_private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.armageddon_vpc01.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${local.name_prefix}-private-subnet0${count.index + 1}"
  }
}
