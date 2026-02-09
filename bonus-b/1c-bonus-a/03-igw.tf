############################################
# VPC + Internet Gateway
############################################

resource "aws_internet_gateway" "armageddon_igw01" {
  vpc_id = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.armageddon_prefix}-igw01"
  }
}
