# ----------------------------------------------------------------
# IAM — Roles (RDS Enhanced Monitoring)
# ----------------------------------------------------------------

# IAM Role - RDS Monitoring Role (CloudWatch)
resource "aws_iam_role" "rds_enhanced_monitoring_role" {
  provider = aws.regional

  name               = "rds-enhanced-monitoring-role-${var.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring_assume_role.json
  description        = "Enhanced RDS Monitoring role for CloudWatch"

  tags = merge(
    {
      Name        = "rds-enhanced-monitoring-role"
      Component   = "iam"
      AccessLevel = "read-only"
      Service     = "rds"
      Scope       = "monitoring-db"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# IAM — Trust Policies (RDS Monitoring Service)
# ----------------------------------------------------------------

data "aws_iam_policy_document" "rds_enhanced_monitoring_assume_role" {
  provider = aws.regional

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
# IAM — Role Policy Attachments (RDS Monitoring)
# ----------------------------------------------------------------

# Policy Attachment - RDS Enhanced Monitoring --> RDS Monitoring Role (CloudWatch)
resource "aws_iam_role_policy_attachment" "attach_rds_enhanced_monitoring_policy" {
  provider = aws.regional

  role       = aws_iam_role.rds_enhanced_monitoring_role.name
  policy_arn = aws_iam_policy.rds_enhanced_monitoring_role.arn
}