# ----------------------------------------------------------------
# NETWORK — LOCALS
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # NETWORKING — Public Subnets
  # ----------------------------------------------------------------

  public_subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]

  public_subnet_cidrs = [
    aws_subnet.public_a.cidr_block,
    aws_subnet.public_b.cidr_block,
    aws_subnet.public_c.cidr_block
  ]

  # ----------------------------------------------------------------
  # NETWORKING — Private App Subnets
  # ----------------------------------------------------------------

  private_app_subnet_ids = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id,
    aws_subnet.private_app_c.id
  ]

  private_app_subnet_cidrs = [
    aws_subnet.private_app_a.cidr_block,
    aws_subnet.private_app_b.cidr_block,
    aws_subnet.private_app_c.cidr_block
  ]

  # ----------------------------------------------------------------
  # NETWORKING — Private Data Subnets
  # ----------------------------------------------------------------

  private_data_subnet_ids = [
    aws_subnet.private_data_a.id,
    aws_subnet.private_data_b.id,
    aws_subnet.private_data_c.id
  ]

  private_data_subnet_cidrs = [
    aws_subnet.private_data_a.cidr_block,
    aws_subnet.private_data_b.cidr_block,
    aws_subnet.private_data_c.cidr_block
  ]

  # ----------------------------------------------------------------
  # NETWORKING — VPC Endpoints
  # ----------------------------------------------------------------

  vpc_endpoints_sg_id = aws_security_group.vpc_endpoints.id

  # ----------------------------------------------------------------
  # TAGGING — Subnet & Endpoint Tags
  # ----------------------------------------------------------------

  public_subnet_tags = {
    Exposure = "public"
    Egress   = "igw"
  }

  private_app_subnet_tags = {
    Exposure = "private"
    Egress   = "nat"
  }

  private_data_subnet_tags = {
    Exposure = "internal-only"
    Egress   = "none"
  }

  vpc_endpoint_tags = {
    Exposure  = "egress-only"
    Egress    = "vpc-endpoint"
    Component = "network"
  }
}

# ----------------------------------------------------------------
# NETWORK — DEMO LOCALS (Not used in deployment)
# ----------------------------------------------------------------

locals {

  # Demo Owner
  demo_owner = lower(var.demo_owner) # Normalization (formatting)

  # Module local derived from module input with transformation.
  # Prefer module-level transformations; use root only when normalization defines deployment identity.
}