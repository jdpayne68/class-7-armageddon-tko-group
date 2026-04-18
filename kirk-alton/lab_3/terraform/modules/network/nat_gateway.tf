# ----------------------------------------------------------------
# NETWORKING — NAT Gateway (Main)
# ----------------------------------------------------------------

# Elastic IP Configuration
resource "aws_eip" "main" {
  provider = aws.regional

  domain = "vpc"
}

# NAT Configuration
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_a.id

  tags = merge(
    {
      Name      = "main-nat-gw-${var.context.env}"
      Component = "network"
    },
    var.context.tags,
    local.public_subnet_tags
  )

  depends_on = [aws_internet_gateway.main]
}