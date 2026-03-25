# ----------------------------------------------------------------
# NETWORKING — VPC
# ----------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "quick-private-vpc-${local.app}-${local.env}"
    Component = "network"
  }
}

# ----------------------------------------------------------------
# NETWORKING — Availability Zones
# ----------------------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"
}