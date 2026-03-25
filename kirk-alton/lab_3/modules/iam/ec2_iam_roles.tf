# ----------------------------------------------------------------
# IAM — Roles (RDS App)
# ----------------------------------------------------------------

# IAM Role - RDS App Role
resource "aws_iam_role" "rds_app" {
  provider = aws.regional

  name               = "rds-app-role-${var.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.rds_app_assume_role.json
  description        = "EC2 role that reads a db secret."

  tags = merge(
    {
      Name        = "rds-app-role"
      Component   = "iam"
      DataClass   = "confidential"
      AccessLevel = "read-only"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# IAM — Trust Policies (EC2 Assume Role)
# ----------------------------------------------------------------

# Trust Policy Data for RDS App role
data "aws_iam_policy_document" "rds_app_assume_role" {
  provider = aws.regional

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------
# IAM — Role Policy Attachments (RDS App Role)
# ----------------------------------------------------------------

# Policy Attachment - SSM Agent Policy --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_ssm_agent_policy" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.ssm_agent_policy.arn
}

# Policy Attachment - EC2 CloudWatch Agent Role --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_ec2_cloudwatch_agent_role" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.ec2_cloudwatch_agent_role.arn
}

# Policy Attachment - Read DB Secret --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_secret" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_secret.arn
}

# Policy Attachment - Read CloudWatch Agent Config File --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_ec2_read_cloudwatch_agent_config" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.ec2_read_cloudwatch_agent_config.arn
}

# Policy Attachment - EC2 Linux Repo Access --> RDS App role
resource "aws_iam_role_policy_attachment" "ec2_linux_repo_access" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.ec2_linux_repo_access.arn
}

# Policy Attachment - Read DB Name Parameter --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_name_parameter" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_name_parameter.arn
}

# Policy Attachment - Read DB Username Parameter --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_username_parameter" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_username_parameter.arn
}

# Policy Attachment - Read DB Host Parameter --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_host_parameter" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_host_parameter.arn
}

# Policy Attachment - Read DB Port Parameter --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_port_parameter" {
  provider = aws.regional

  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_port_parameter.arn
}