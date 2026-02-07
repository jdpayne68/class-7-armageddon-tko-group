# IAM Role - RDS Monitoring Role (CloudWatch)
resource "aws_iam_role" "rds_enhanced_monitoring_role" {
  name               = "rds-enhanced-monitoring-role-${local.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring_assume_role.json
  description        = "Service role used by RDS Enhanced Monitoring to publish metrics/logs to CloudWatch."

  tags = {
    Name        = "rds-enhanced-monitoring-role"
    Component   = "iam"
    AccessLevel = "read-only"
    Service     = "rds"
    Scope       = "monitoring-db"
  }
}

# Trust Policy Data for RDS Enhanced Monitoring role
data "aws_iam_policy_document" "rds_enhanced_monitoring_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# Policy Attachment - RDS Enhanced Monitoring --> RDS Monitoring Role
# Recommended: AWS-managed policy for Enhanced Monitoring
resource "aws_iam_role_policy_attachment" "attach_rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# # Policy Attachment - RDS Enhanced Monitoring --> RDS Monitoring Role (CloudWatch)
# resource "aws_iam_role_policy_attachment" "attach_attach_rds_enhanced_monitoring" {
#   role       = aws_iam_role.rds_enhanced_monitoring_role.name
#   policy_arn = aws_iam_policy.rds_enhanced_monitoring_role.arn

# }