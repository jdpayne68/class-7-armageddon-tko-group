############################################
# VPC Endpoint - S3 (Gateway)
############################################

# Explanation: S3 is the supply depot—without this, your private world starves (updates, artifacts, logs).
resource "aws_vpc_endpoint" "armageddon_vpce_s3_gw01" {
  vpc_id            = aws_vpc.armageddon_vpc01.id
  service_name      = "com.amazonaws.${data.aws_region.armageddon_region01.id}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.armageddon_private_rt01.id
  ]

  tags = {
    Name = "${local.armageddon_prefix}-vpce-s3-gw01"
  }
}

############################################
# VPC Endpoints - SSM (Interface)
############################################

# Explanation: SSM is your Force choke—remote control without SSH, and nobody sees your keys.
resource "aws_vpc_endpoint" "armageddon_vpce_ssm01" {
  vpc_id              = aws_vpc.armageddon_vpc01.id
  service_name        = "com.amazonaws.${data.aws_region.armageddon_region01.id}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.armageddon_private_subnets[*].id
  security_group_ids = [aws_security_group.armageddon_vpce_sg01.id]

  tags = {
    Name = "${local.armageddon_prefix}-vpce-ssm01"
  }
}

# Explanation: ec2messages is the Wookiee messenger—SSM sessions won’t work without it.
resource "aws_vpc_endpoint" "armageddon_vpce_ec2messages01" {
  vpc_id              = aws_vpc.armageddon_vpc01.id
  service_name        = "com.amazonaws.${data.aws_region.armageddon_region01.id}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.armageddon_private_subnets[*].id
  security_group_ids = [aws_security_group.armageddon_vpce_sg01.id]

  tags = {
    Name = "${local.armageddon_prefix}-vpce-ec2messages01"
  }
}

# Explanation: ssmmessages is the holonet channel—Session Manager needs it to talk back.
resource "aws_vpc_endpoint" "armageddon_vpce_ssmmessages01" {
  vpc_id              = aws_vpc.armageddon_vpc01.id
  service_name        = "com.amazonaws.${data.aws_region.armageddon_region01.id}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.armageddon_private_subnets[*].id
  security_group_ids = [aws_security_group.armageddon_vpce_sg01.id]

  tags = {
    Name = "${local.armageddon_prefix}-vpce-ssmmessages01"
  }
}

############################################
# VPC Endpoint - CloudWatch Logs (Interface)
############################################

# Explanation: CloudWatch Logs is the ship’s black box—armageddon wants crash data, always.
resource "aws_vpc_endpoint" "armageddon_vpce_logs01" {
  vpc_id              = aws_vpc.armageddon_vpc01.id
  service_name        = "com.amazonaws.${data.aws_region.armageddon_region01.id}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.armageddon_private_subnets[*].id
  security_group_ids = [aws_security_group.armageddon_vpce_sg01.id]

  tags = {
    Name = "${local.armageddon_prefix}-vpce-logs01"
  }
}

############################################
# VPC Endpoint - Secrets Manager (Interface)
############################################

# Explanation: Secrets Manager is the locked vault—armageddon doesn’t put passwords on sticky notes.
resource "aws_vpc_endpoint" "armageddon_vpce_secrets01" {
  vpc_id              = aws_vpc.armageddon_vpc01.id
  service_name        = "com.amazonaws.${data.aws_region.armageddon_region01.id}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.armageddon_private_subnets[*].id
  security_group_ids = [aws_security_group.armageddon_vpce_sg01.id]

  tags = {
    Name = "${local.armageddon_prefix}-vpce-secrets01"
  }
}

############################################
# Optional: VPC Endpoint - KMS (Interface)
############################################

# Explanation: KMS is the encryption kyber crystal—armageddon prefers locked doors AND locked safes.
resource "aws_vpc_endpoint" "armageddon_vpce_kms01" {
  vpc_id              = aws_vpc.armageddon_vpc01.id
  service_name        = "com.amazonaws.${data.aws_region.armageddon_region01.id}.kms"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = aws_subnet.armageddon_private_subnets[*].id
  security_group_ids = [aws_security_group.armageddon_vpce_sg01.id]

  tags = {
    Name = "${local.armageddon_prefix}-vpce-kms01"
  }
}
