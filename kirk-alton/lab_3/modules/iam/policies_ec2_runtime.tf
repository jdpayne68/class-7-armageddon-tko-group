# ----------------------------------------------------------------
# IAM — Policies (EC2 Access)
# ----------------------------------------------------------------

# Allow EC2 to Access Amazon Linux Repo via VPC Endpoint
resource "aws_iam_policy" "ec2_linux_repo_access" {
  provider = aws.regional

  name   = "ec2-linux-repo-access-policy"
  policy = data.aws_iam_policy_document.ec2_linux_repo_access.json

  tags = merge(
    {
      Name        = "ec2-linux-repo-access"
      Component   = "iam"
      AccessLevel = "read-only"
    },
    var.context.tags
  )
}

# IAM Policy Data - Allow EC2 to Access Amazon Linux Repo via VPC Endpoint
data "aws_iam_policy_document" "ec2_linux_repo_access" {
  provider = aws.regional

  statement {
    sid    = "AllowEC2LinuxRepoAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::al2023-repos-us-east-1-de612dc2/*"
    ]
  }
}

# ----------------------------------------------------------------
# IAM — Policies (EC2 CloudWatch Agent)
# ----------------------------------------------------------------

# IAM Policy Object - EC2 CloudWatch Agent Role
resource "aws_iam_policy" "ec2_cloudwatch_agent_role" {
  provider = aws.regional

  name   = "ec2-cloudwatch-agent-role"
  policy = data.aws_iam_policy_document.ec2_cloudwatch_agent_role.json

  tags = merge(
    {
      Name        = "ec2-cloudwatch-agent-role-policy"
      Component   = "iam"
      AccessLevel = "write"
    },
    var.context.tags
  )
}

# IAM Policy Data - EC2 CloudWatch Agent Role
data "aws_iam_policy_document" "ec2_cloudwatch_agent_role" {
  provider = aws.regional

  # Allow CloudWatch Agent to write metric data to CloudWatch Metrics
  statement {
    sid    = "AllowCloudWatchMetrics"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData"
    ]

    resources = ["*"] # CloudWatch doesn't support ARNs for PutMetricData

    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["CWAgent"]
    }
  }

  # Allow CloudWatch Agent to manage log groups
  statement {
    sid    = "AllowEC2LogGroupActions"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups"
    ]

    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:*",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/ec2/cloudwatch-agent/rds-app-${var.name_suffix}",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ec2-system-logs-${var.name_suffix}"
    ]
  }

  # Allow CloudWatch Agent to write log streams
  statement {
    sid    = "AllowEC2LogStreamActions"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ec2-system-logs-${var.name_suffix}:log-stream:*",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/ec2/cloudwatch-agent/rds-app-${var.name_suffix}:log-stream:*"
    ]
  }
}