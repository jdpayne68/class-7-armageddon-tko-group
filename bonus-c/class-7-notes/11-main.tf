locals {
  name_prefix = var.project_name
}

resource "aws_vpc" "armageddon_vpc01" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc01"
  }
}
