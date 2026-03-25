# ----------------------------------------------------------------
# NETWORKING — Internet Gateway
# ----------------------------------------------------------------

resource "aws_internet_gateway" "main" {
  provider = aws.regional

  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name      = "main-igw-${var.context.env}"
      Component = "network"
    },
    var.context.tags,
    local.public_subnet_tags
  )
}