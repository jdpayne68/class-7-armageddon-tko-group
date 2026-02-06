# -------------------------------------------------------------------------------
# EC2 Policies
# -------------------------------------------------------------------------------

# IAM Policy Object - Read DB Secret
resource "aws_iam_policy" "read_db_secret" {
  name        = "read-db-secret-${local.name_suffix}"
  path        = "/"
  description = "Read specific secret for db."

  policy = data.aws_iam_policy_document.read_db_secret.json

  tags = {
    Name      = "read-db-secret"
    Component = "iam"
    DataClass = "confidential"
  }
}

# IAM Policy Data - Read DB Secret
data "aws_iam_policy_document" "read_db_secret" {
  statement {
    sid    = "ReadDBSecret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.lab_rds_mysql.arn
    ]
  }
}


# IAM Policy Object - Read DB Connection Parameters
resource "aws_iam_policy" "read_db_connection_parameters" {
  name        = "read-db-connection-parameters-${local.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB connection info (host, port, username) from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_connection_parameters.json

  tags = {
    Name         = "read-db-connection-parameters"
    Component    = "iam"
    AppComponent = "credentials"
    DataClass    = "internal"
    AccessLevel  = "read-only"
  }
}

# IAM Policy Data - Read DB Connection Parameters
data "aws_iam_policy_document" "read_db_connection_parameters" {
  statement {
    sid    = "ReadDBConnectionParameters"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lab/rds/mysql/*"
    ]
  }
}


# -------------------------------------------------------------------------------
# RDS Policies
# -------------------------------------------------------------------------------

# IAM Policy Object - RDS Enhanced Monitoring Role (CloudWatch)
resource "aws_iam_policy" "rds_enhanced_monitoring_role" {
  name        = "rds-enhanced-monitoring-role-${local.name_suffix}"
  path        = "/"
  description = "Gives RDS permission to create CloudWatch log groups and streams, and write logs to them."

  policy = data.aws_iam_policy_document.rds_enhanced_monitoring_role.json

  tags = {
    Name      = "rds-enhanced-monitoring-role"
    Component = "iam"
  }
}


# IAM Policy Data - RDS Enhanced Monitoring Role
data "aws_iam_policy_document" "rds_enhanced_monitoring_role" {
  statement {
    sid       = "EnableCreationAndManagementOfRDSCloudwatchLogGroups"
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:PutRetentionPolicy"]
    resources = ["arn:aws:logs:*:*:log-group:RDS*"]
  }

  statement {
    sid       = "EnableCreationAndManagementOfRDSCloudwatchLogStreams"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams", "logs:GetLogEvents"]
    resources = ["arn:aws:logs:*:*:log-group:RDS*:log-stream:*"]
  }
}

# -------------------------------------------------------------------------------
# Flow Log Policies
# -------------------------------------------------------------------------------

# IAM Policy Object - VPC Flow Log
resource "aws_iam_policy" "vpc_flow_log_role" {
  name   = "vpc-flow-log-role-policy"
  policy = data.aws_iam_policy_document.vpc_flow_log_role.json
}


# IAM Policy Data - VPC Flow Log
data "aws_iam_policy_document" "vpc_flow_log_role" {
  statement {
    sid    = "AllowVPCFlowLogWrites"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["${aws_cloudwatch_log_group.vpc_flow_log.arn}", "${aws_cloudwatch_log_group.vpc_flow_log.arn}:log-stream:*"]
  }
}