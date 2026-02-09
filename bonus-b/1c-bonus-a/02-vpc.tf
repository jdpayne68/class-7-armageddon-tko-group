############################################
# VPC + Internet Gateway
############################################

# Explanation: armageddon needs a hyperlane—this VPC is the Millennium Falcon’s flight corridor.
resource "aws_vpc" "armageddon_vpc01" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.armageddon_prefix}-vpc01"
  }
}
