# ----------------------------------------------------------------
# DATABASE — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — Subnets
# ----------------------------------------------------------------

output "rds_subnets" {
  description = "Subnet IDs for the RDS subnet group."
  value       = aws_db_subnet_group.lab_mysql.subnet_ids
}

# ----------------------------------------------------------------
# OUTPUTS — Database
# ----------------------------------------------------------------

output "db_endpoint" {
  description = "RDS endpoint address."
  value       = aws_db_instance.lab_mysql.endpoint
}

output "db_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.lab_mysql.identifier
}

# ----------------------------------------------------------------
# OUTPUTS — Secrets
# ----------------------------------------------------------------

output "db_secret_arn" {
  description = "Secrets Manager ARN for DB credentials."
  value       = aws_secretsmanager_secret.lab_rds_mysql.arn
}