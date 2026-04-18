# ----------------------------------------------------------------
# IAM — RDS Enhanced Monitoring Role
# ----------------------------------------------------------------

# IAM Role - RDS Monitoring Role (CloudWatch)
resource "aws_iam_role" "rds_enhanced_monitoring_role" {
  name               = "rds-enhanced-monitoring-role-${local.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring_assume_role.json
  description        = "Enhanced RDS Monitoring role for CloudWatch"

  tags = {
    Name        = "rds-enhanced-monitoring-role"
    Component   = "iam"
    AccessLevel = "read-only"
    Service     = "rds"
    Scope       = "monitoring-db"
  }
}

# ----------------------------------------------------------------
# IAM — Trust Policy (RDS Monitoring Service)
# ----------------------------------------------------------------

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
# ----------------------------------------------------------------
# IAM — Role Policy Attachment
# ----------------------------------------------------------------

# Policy Attachment - RDS Enhanced Monitoring --> RDS Monitoring Role (CloudWatch)
resource "aws_iam_role_policy_attachment" "attach_rds_enhanced_monitoring_policy" {
  role       = aws_iam_role.rds_enhanced_monitoring_role.name
  policy_arn = aws_iam_policy.rds_enhanced_monitoring_role.arn
}