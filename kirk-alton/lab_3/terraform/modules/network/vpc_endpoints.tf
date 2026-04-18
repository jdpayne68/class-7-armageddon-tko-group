# ----------------------------------------------------------------
# NETWORKING — VPC ENDPOINTS (Key Management)
# ----------------------------------------------------------------

# Interface Endpoint - KMS
resource "aws_vpc_endpoint" "kms" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.context.region}.kms"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_app_subnet_ids

  security_group_ids = [
    local.vpc_endpoints_sg_id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      Name = "vpc-endpoint-kms"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}

# ----------------------------------------------------------------
# NETWORKING — VPC ENDPOINTS (Storage)
# ----------------------------------------------------------------

# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  provider = aws.regional

  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.context.region}.s3"

  tags = merge(
    {
      Name = "vpc-endpoint-s3"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}

# ----------------------------------------------------------------
# NETWORKING — VPC ENDPOINTS (Secrets & Configuration)
# ----------------------------------------------------------------

# Interface Endpoint - Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.context.region}.secretsmanager"
  vpc_endpoint_type = "Interface"

  subnet_ids = local.private_app_subnet_ids

  security_group_ids = [
    local.vpc_endpoints_sg_id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      Name = "vpc-endpoint-secretsmanager"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}

# ----------------------------------------------------------------
# NETWORKING — VPC ENDPOINTS (Systems Manager)
# ----------------------------------------------------------------

# Interface Endpoint - Systems Manager
resource "aws_vpc_endpoint" "ssm" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.context.region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = local.private_app_subnet_ids

  security_group_ids = [
    local.vpc_endpoints_sg_id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      Name = "vpc-endpoint-ssm"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}

# Interface Endpoint - Systems Manager Messages
resource "aws_vpc_endpoint" "ssm_messages" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.context.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids = local.private_app_subnet_ids

  security_group_ids = [
    local.vpc_endpoints_sg_id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      Name = "vpc-endpoint-ssm-messages"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}

# Interface Endpoint - Systems Manager EC2 Messages
resource "aws_vpc_endpoint" "ec2_messages" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.context.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids = local.private_app_subnet_ids

  security_group_ids = [
    local.vpc_endpoints_sg_id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      Name = "vpc-endpoint-ec2-messages"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}

# ----------------------------------------------------------------
# NETWORKING — VPC ENDPOINTS (Compute)
# ----------------------------------------------------------------

# Interface Endpoint - EC2
resource "aws_vpc_endpoint" "ec2" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.context.region}.ec2"
  vpc_endpoint_type = "Interface"

  subnet_ids = local.private_app_subnet_ids

  security_group_ids = [
    local.vpc_endpoints_sg_id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      Name = "vpc-endpoint-ec2"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}

# ----------------------------------------------------------------
# NETWORKING — VPC ENDPOINTS (Monitoring & Logging)
# ----------------------------------------------------------------

# Interface Endpoint - CloudWatch Monitoring
resource "aws_vpc_endpoint" "monitoring" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.context.region}.monitoring"
  vpc_endpoint_type = "Interface"

  subnet_ids = local.private_app_subnet_ids

  security_group_ids = [
    local.vpc_endpoints_sg_id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      Name = "vpc-endpoint-monitoring"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}

# Interface Endpoint - CloudWatch Logs
resource "aws_vpc_endpoint" "logs" {
  provider = aws.regional

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.context.region}.logs"
  vpc_endpoint_type = "Interface"

  subnet_ids = local.private_app_subnet_ids

  security_group_ids = [
    local.vpc_endpoints_sg_id
  ]

  private_dns_enabled = true

  tags = merge(
    {
      Name = "vpc-endpoint-logs"
    },
    var.context.tags, local.private_data_subnet_tags
  )
}