# IAM Role - RDS App Role
resource "aws_iam_role" "rds_app" {
  name               = "rds-app-role-${local.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.rds_app_assume_role.json
  description        = "EC2 role that reads a db secret."

  tags = {
    Name        = "rds-app-role"
    Component   = "iam"
    DataClass   = "confidential"
    AccessLevel = "read-only"
  }
}

# Trust Policy Data for RDS App role
data "aws_iam_policy_document" "rds_app_assume_role" {
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


# Policy Attachment - SSM Agent Policy --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_ssm_agent_policy" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.ssm_agent_policy.arn
}

# Policy Attachment - EC2 CloudWatch Agent Role --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_ec2_cloudwatch_agent_role" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.ec2_cloudwatch_agent_role.arn
}

# Policy Attachment - Read DB Secret --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_secret" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_secret.arn
}


# Policy Attachment - Read CloudWatch Agent Config File --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_cloudwatch_agent_config" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_cloudwatch_agent_config.arn
}


# Policy Attachment - EC2 Linux Repo Access --> RDS App role
resource "aws_iam_role_policy_attachment" "ec2_linux_repo_access" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.ec2_linux_repo_access.arn
}


# Policy Attachment - Read DB Name Parameter --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_name_parameter" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_name_parameter.arn
}

# Policy Attachment - Read DB Username Parameter --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_username_parameter" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_username_parameter.arn
}

# Policy Attachment - Read DB Host Parameter --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_host_parameter" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_host_parameter.arn
}

# Policy Attachment - Read DB Port Parameter --> RDS App role
resource "aws_iam_role_policy_attachment" "attach_read_db_port_parameter" {
  role       = aws_iam_role.rds_app.name
  policy_arn = aws_iam_policy.read_db_port_parameter.arn
}