# ----------------------------------------------------------------
# IAM — Policies (CloudWatch Agent Configuration)
# ----------------------------------------------------------------

# IAM Policy Object - Read CloudWatch Agent Config File
resource "aws_iam_policy" "ec2_read_cloudwatch_agent_config" {
  provider = aws.regional

  name        = "read-cloudwatch-agent-config-${var.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read CloudWatch Agent Config File"

  policy = data.aws_iam_policy_document.ec2_read_cloudwatch_agent_config.json

  tags = merge(
    {
      Name         = "read-cloudwatch-agent-config"
      Component    = "iam"
      AppComponent = "logging-configuration"
      DataClass    = "internal"
      AccessLevel  = "read-only"
    },
    var.context.tags
  )
}

# IAM Policy Data - CloudWatch Agent Config File
data "aws_iam_policy_document" "ec2_read_cloudwatch_agent_config" {
  provider = aws.regional

  statement {
    sid    = "ReadCloudWatchAgentConfig"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/rds-app/cloudwatch-agent/config-${var.name_suffix}"
    ]
  }
}

# ----------------------------------------------------------------
# IAM — Policies (RDS Enhanced Monitoring)
# ----------------------------------------------------------------

# IAM Policy Object - RDS Enhanced Monitoring Role (CloudWatch)
resource "aws_iam_policy" "rds_enhanced_monitoring_role" {
  provider = aws.regional

  name        = "rds-enhanced-monitoring-role-${var.name_suffix}"
  path        = "/"
  description = "Gives RDS permission to create CloudWatch log groups and streams, and write logs to them."

  policy = data.aws_iam_policy_document.rds_enhanced_monitoring_role.json

  tags = merge(
    {
      Name      = "rds-enhanced-monitoring-role-policy"
      Component = "iam"
    },
    var.context.tags
  )
}

# IAM Policy Data - RDS Enhanced Monitoring Role
data "aws_iam_policy_document" "rds_enhanced_monitoring_role" {
  provider = aws.regional

  statement {
    sid       = "AllowRdsLogGroupActions"
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:PutRetentionPolicy"]
    resources = ["arn:aws:logs:*:*:log-group:RDS*"]
  }

  statement {
    sid    = "AllowRdsLogStreamActions"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:log-group:RDS*:log-stream:*"]
  }
}

# ----------------------------------------------------------------
# IAM — Policies (VPC Flow Logs)
# ----------------------------------------------------------------

# IAM Policy Object - VPC Flow Log
resource "aws_iam_policy" "vpc_flow_log_role" {
  provider = aws.regional

  name   = "vpc-flow-log-role-policy"
  policy = data.aws_iam_policy_document.vpc_flow_log_role.json

  tags = merge(
    {
      Name      = "vpc-flow-log-role-policy"
      Component = "iam"
    },
    var.context.tags
  )
}

# IAM Policy Data - VPC Flow Log
data "aws_iam_policy_document" "vpc_flow_log_role" {
  provider = aws.regional

  statement {
    sid    = "AllowVpcLogGroupActions"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups"
    ]

    resources = [
      "${var.vpc_flow_log_group_arn}"
    ]
  }

  statement {
    sid    = "AllowVpcLogStreamActions"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "${var.vpc_flow_log_group_arn}:log-stream:*"
    ]
  }
}