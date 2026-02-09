resource "aws_internet_gateway" "armageddon_igw01" {
  vpc_id = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.name_prefix}-igw01"
  }
}
