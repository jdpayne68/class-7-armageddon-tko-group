# ----------------------------------------------------------------
# NETWORK — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — VPC
# ----------------------------------------------------------------

output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block."
  value       = aws_vpc.main.cidr_block
}

output "vpc_name" {
  description = "VPC name tag."
  value       = aws_vpc.main.tags["Name"]
}

# ----------------------------------------------------------------
# OUTPUTS — Subnets
# ----------------------------------------------------------------

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = local.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs."
  value       = local.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Private data subnet IDs."
  value       = local.private_data_subnet_ids
}

# ----------------------------------------------------------------
# OUTPUTS — Subnet Tags
# ----------------------------------------------------------------

output "public_subnet_tags" {
  description = "Tags for public subnets."
  value       = local.public_subnet_tags
}

output "private_app_subnet_tags" {
  description = "Tags for private app subnets."
  value       = local.private_app_subnet_tags
}

output "private_subnet_tags" {
  description = "Tags for private data subnets."
  value       = local.private_data_subnet_tags
}

# ----------------------------------------------------------------
# OUTPUTS — VPC Endpoints
# ----------------------------------------------------------------

output "ec2_vpc_endpoints_ready" {
  description = "VPC endpoint IDs (dependency guard)."
  value = [
    aws_vpc_endpoint.s3.id,
    aws_vpc_endpoint.ssm.id,
    aws_vpc_endpoint.ssm_messages.id,
    aws_vpc_endpoint.ec2_messages.id,
    aws_vpc_endpoint.secretsmanager.id,
    aws_vpc_endpoint.logs.id
  ]
}

output "vpc_endpoints_sg_id" {
  description = "VPC endpoints security group ID."
  value       = aws_security_group.vpc_endpoints.id
}

output "vpc_endpoints_sg_arn" {
  description = "VPC endpoints security group ARN."
  value       = aws_security_group.vpc_endpoints.arn
}

output "vpc_endpoints_sg_name" {
  description = "VPC endpoints security group name."
  value       = aws_security_group.vpc_endpoints.name
}

# ----------------------------------------------------------------
# OUTPUTS — Demo
# ----------------------------------------------------------------

output "demo_owner_normalized" {
  description = "Normalized demo owner."
  value       = local.demo_owner
}