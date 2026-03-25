# ----------------------------------------------------------------
# NETWORKING — VPC
# ----------------------------------------------------------------

resource "aws_vpc" "main" {
  provider = aws.regional

  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name      = "vpc-${var.context.app}-${var.context.env}"
      Component = "network"
    },
    var.context.tags
  )
}