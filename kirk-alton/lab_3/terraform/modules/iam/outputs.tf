# ----------------------------------------------------------------
# IAM — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — RDS Monitoring Role
# ----------------------------------------------------------------

output "rds_enhanced_monitoring_role_name" {
  description = "RDS monitoring role name."
  value       = aws_iam_role.rds_enhanced_monitoring_role.name
}

output "rds_enhanced_monitoring_role_arn" {
  description = "RDS monitoring role ARN."
  value       = aws_iam_role.rds_enhanced_monitoring_role.arn
}

output "rds_enhanced_monitoring_role_id" {
  description = "RDS monitoring role ID."
  value       = aws_iam_role.rds_enhanced_monitoring_role.id
}

# ----------------------------------------------------------------
# OUTPUTS — RDS App Role
# ----------------------------------------------------------------

output "rds_app_role_name" {
  description = "App IAM role name."
  value       = aws_iam_role.rds_app.name
}

output "rds_app_role_arn" {
  description = "App IAM role ARN."
  value       = aws_iam_role.rds_app.arn
}

output "rds_app_role_id" {
  description = "App IAM role ID."
  value       = aws_iam_role.rds_app.id
}

# ----------------------------------------------------------------
# OUTPUTS — Instance Profile
# ----------------------------------------------------------------

output "rds_app_instance_profile_name" {
  description = "Instance profile name."
  value       = aws_iam_instance_profile.rds_app.name
}

output "rds_app_instance_profile_arn" {
  description = "Instance profile ARN."
  value       = aws_iam_instance_profile.rds_app.arn
}

# ----------------------------------------------------------------
# OUTPUTS — VPC Flow Logs Role
# ----------------------------------------------------------------

output "vpc_flow_log_role_name" {
  description = "VPC flow log role name."
  value       = aws_iam_role.vpc_flow_log_role.name
}

output "vpc_flow_log_role_arn" {
  description = "VPC flow log role ARN."
  value       = aws_iam_role.vpc_flow_log_role.arn
}

output "vpc_flow_log_role_id" {
  description = "VPC flow log role ID."
  value       = aws_iam_role.vpc_flow_log_role.id
}

# ----------------------------------------------------------------
# OUTPUTS — Firehose Role (Conditional)
# ----------------------------------------------------------------

output "firehose_network_telemetry_role_name" {
  description = "Firehose role name."
  value       = try(aws_iam_role.firehose_network_telemetry_role[0].name, null)
}

output "firehose_network_telemetry_role_arn" {
  description = "Firehose role ARN."
  value       = try(aws_iam_role.firehose_network_telemetry_role[0].arn, null)
}

output "firehose_network_telemetry_role_id" {
  description = "Firehose role ID."
  value       = try(aws_iam_role.firehose_network_telemetry_role[0].id, null)
}