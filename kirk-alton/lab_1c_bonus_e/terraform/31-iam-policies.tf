# -------------------------------------------------------------------------------
# SSM Agent Permissions
# -------------------------------------------------------------------------------

# IAM Policy Object - SSM Agent Policy
resource "aws_iam_policy" "ssm_agent_policy" {
  name        = "SSMAgentPolicy"
  path        = "/"
  description = "Allow SSM Agent Permissions"

  policy = data.aws_iam_policy_document.ssm_agent_policy.json

  tags = {
    Name      = "ssm-agent-policy"
    Component = "instance-management"
  }

}
# IAM Policy Data - SSM Agent Policy (SSM Agent Permissions, Messaging, and Legacy Messaging)
data "aws_iam_policy_document" "ssm_agent_policy" {
  statement {
    sid    = "AllowSSMAgentPermissions"
    effect = "Allow"
    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowSSMChannelMessaging"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowSSMLegacyMessaging"
    effect = "Allow"
    actions = [
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply"
    ]
    resources = ["*"]
  }
}


# -------------------------------------------------------------------------------
# EC2 Policies
# -------------------------------------------------------------------------------

# Allow EC2 to Access Amazon Linux Repo via VPC Endpoint
resource "aws_iam_policy" "ec2_linux_repo_access" {
  name   = "ec2-linux-repo-access-policy"
  policy = data.aws_iam_policy_document.ec2_linux_repo_access.json

  tags = {
    Name        = "ec2-linux-repo-access"
    Component   = "iam"
    AccessLevel = "read-only"
  }
}
# IAM Policy Data - Allow EC2 to Access Amazon Linux Repo via VPC Endpoint
data "aws_iam_policy_document" "ec2_linux_repo_access" {
  statement {
    sid    = "AllowEC2LinuxRepoAccess"
    effect = "Allow"

    actions = ["s3:GetObject"]

    resources = ["arn:aws:s3:::al2023-repos-us-east-1-de612dc2/*"]
  }
}


# IAM Policy Object - EC2 CloudWatch Agent Role
resource "aws_iam_policy" "ec2_cloudwatch_agent_role" {
  name   = "ec2-cloudwatch-agent-role"
  policy = data.aws_iam_policy_document.ec2_cloudwatch_agent_role.json

  tags = {
    Name        = "ec2-cloudwatch-agent-role"
    Component   = "iam"
    AccessLevel = "write"
  }
}
# IAM Policy Data - EC2 CloudWatch Agent Role
data "aws_iam_policy_document" "ec2_cloudwatch_agent_role" {

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
  # Allow CloudWatch Agent to write log data to CloudWatch Logs
  statement {
    sid    = "AllowEC2LogGroupActions"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:*",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/ec2/cloudwatch-agent/rds-app-${local.name_suffix}",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ec2-system-logs-${local.name_suffix}"
    ]
  }

  statement {
    sid    = "AllowEC2LogStreamActions"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ec2-system-logs-${local.name_suffix}:log-stream:*",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/ec2/cloudwatch-agent/rds-app-${local.name_suffix}:log-stream:*"
    ]
  }
}

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
      aws_secretsmanager_secret.lab_rds_mysql.arn,
      "${aws_secretsmanager_secret.lab_rds_mysql.arn}-*"
    ]
  }
}


# IAM Policy Object - Read CloudWatch Agent Config File
resource "aws_iam_policy" "read_cloudwatch_agent_config" {
  name        = "read-cloudwatch-agent-config-${local.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read CloudWatch Agent Config File"

  policy = data.aws_iam_policy_document.read_cloudwatch_agent_config.json

  tags = {
    Name         = "read-cloudwatch-agent-config"
    Component    = "iam"
    AppComponent = "logging-configuration"
    DataClass    = "internal"
    AccessLevel  = "read-only"
  }
}
# IAM Policy Data - CloudWatch Agent Config File
data "aws_iam_policy_document" "read_cloudwatch_agent_config" {
  statement {
    sid    = "ReadCloudWatchAgentConfig"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters", # Allows retrieval of multiple parameters at once
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/rds-app/cloudwatch-agent/config-${local.name_suffix}"
    ]
  }
}


# IAM Policy Object - Read DB Name Parameter
resource "aws_iam_policy" "read_db_name_parameter" {
  name        = "read-db-name-parameter-${local.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB name from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_name_parameter.json

  tags = {
    Name         = "read-db-name-parameter"
    Component    = "iam"
    AppComponent = "credentials"
    DataClass    = "internal"
    AccessLevel  = "read-only"
  }
}
# IAM Policy Data - Read DB Name Parameter
data "aws_iam_policy_document" "read_db_name_parameter" {
  statement {
    sid    = "ReadDbNameParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lab/rds/mysql/db-name-${local.name_suffix}"
    ]
  }
}


# IAM Policy Object - Read DB Username Parameter
resource "aws_iam_policy" "read_db_username_parameter" {
  name        = "read-db-username-parameter-${local.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB username from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_username_parameter.json

  tags = {
    Name         = "read-db-username-parameter"
    Component    = "iam"
    AppComponent = "credentials"
    DataClass    = "internal"
    AccessLevel  = "read-only"
  }
}
# IAM Policy Data - Read DB Username Parameter
data "aws_iam_policy_document" "read_db_username_parameter" {
  statement {
    sid    = "ReadDbUsernameParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lab/rds/mysql/db-username-${local.name_suffix}"
    ]
  }
}


# IAM Policy Object - Read DB Host Parameter
resource "aws_iam_policy" "read_db_host_parameter" {
  name        = "read-db-host-parameter-${local.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB host from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_host_parameter.json

  tags = {
    Name         = "read-db-host-parameter"
    Component    = "iam"
    AppComponent = "credentials"
    DataClass    = "internal"
    AccessLevel  = "read-only"
  }
}
# IAM Policy Data - Read DB Host Parameter
data "aws_iam_policy_document" "read_db_host_parameter" {
  statement {
    sid    = "ReadDbHostParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lab/rds/mysql/db-host-${local.name_suffix}"
    ]
  }
}


# IAM Policy Object - Read DB Port Parameter
resource "aws_iam_policy" "read_db_port_parameter" {
  name        = "read-db-port-parameter-${local.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB port from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_port_parameter.json

  tags = {
    Name         = "read-db-port-parameter"
    Component    = "iam"
    AppComponent = "credentials"
    DataClass    = "internal"
    AccessLevel  = "read-only"
  }
}
# IAM Policy Data - Read DB Port Parameter
data "aws_iam_policy_document" "read_db_port_parameter" {
  statement {
    sid    = "ReadDbPortParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lab/rds/mysql/db-port-${local.name_suffix}"
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
    sid       = "AllowRdsLogGroupActions"
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:PutRetentionPolicy"]
    resources = ["arn:aws:logs:*:*:log-group:RDS*"]
  }

  statement {
    sid       = "AllowRdsLogStreamActions"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams", "logs:GetLogEvents"]
    resources = ["arn:aws:logs:*:*:log-group:RDS*:log-stream:*"]
  }
}

# -------------------------------------------------------------------------------
# VPC Flow Log Policies
# -------------------------------------------------------------------------------

# IAM Policy Object - VPC Flow Log
resource "aws_iam_policy" "vpc_flow_log_role" {
  name   = "vpc-flow-log-role-policy"
  policy = data.aws_iam_policy_document.vpc_flow_log_role.json
}
# IAM Policy Data - VPC Flow Log
data "aws_iam_policy_document" "vpc_flow_log_role" {
  statement {
    sid    = "AllowVpcLogGroupActions"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
    ]

    resources = ["${aws_cloudwatch_log_group.vpc_flow_log.arn}"]
  }

  statement {
    sid    = "AllowVpcLogStreamActions"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = ["${aws_cloudwatch_log_group.vpc_flow_log.arn}:log-stream:*"]
  }
}


# -------------------------------------------------------------------------------
# Kinesis Firehose IAM Policies
# -------------------------------------------------------------------------------


# IAM Policy Object - Firehose Network Telemetry Logs
resource "aws_iam_policy" "firehose_network_telemetry_logs" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0

  name   = "firehose-network-telemetry-logs"
  policy = data.aws_iam_policy_document.firehose_network_telemetry_logs[0].json
}

# Conditional IAM Policy Data - Firehose Network Telemetry Logs
data "aws_iam_policy_document" "firehose_network_telemetry_logs" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0

  # Allow Firehose to write diagnostic logs to CloudWatch
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.waf_firehose_logs[0].arn}:*"
    ]
  }

  # Allow Firehose to deliver data to S3 (REQUIRED)
  # NOTE: Keep experimenting with splitting policy statements by scope. Its more logical, easier to see intent, and makes refactoring easier in the future.

  # Bucket-level permissions
  statement {
    sid       = "FirehoseBucketMetadata"
    actions   = ["s3:GetBucketLocation", "s3:ListBucket"]
    resources = [aws_s3_bucket.waf_firehose_logs[0].arn]
  }

  # Object-level permissions
  statement {
    sid       = "FirehoseObjectWrite"
    actions   = ["s3:PutObject", "s3:AbortMultipartUpload"]
    resources = ["${aws_s3_bucket.waf_firehose_logs[0].arn}/*"]
  }
}


# # IAM Policy Object - Firehose Network Telemetry Invoke Lambda
# resource "aws_iam_policy" "firehose_network_telemetry_invoke_lambda" {
#   name   = "firehose-network-telemetry-invoke-lambda"
#   policy = data.aws_iam_policy_document.firehose_network_telemetry_invoke_lambda.json
# }
# # IAM Policy Data - Firehose Network Telemetry Invoke Lambda
# data "aws_iam_policy_document" "firehose_network_telemetry_invoke_lambda" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "lambda:InvokeFunction"
#     ]

#     resources = [
#       aws_lambda_function.lambda_firehose_network_telemetry_processor.arn
#     ]
#   }
# }


# -------------------------------------------------------------------------------
# Lambda IAM Policies
# -------------------------------------------------------------------------------

# IAM Policy Object - Lambda Firehose Network Telemetry Logs
resource "aws_iam_policy" "lambda_firehose_network_telemetry_logs" {
  name   = "lambda-firehose-network-telemetry-logs"
  policy = data.aws_iam_policy_document.lambda_firehose_network_telemetry_logs.json
}
# IAM Policy Data - Lambda Firehose Network Telemetry Logs
data "aws_iam_policy_document" "lambda_firehose_network_telemetry_logs" {
  statement {
    sid    = "LambdaLogGroupActions"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*"
    ]
  }
}


# # IAM Policy Object - Lambda S3 ETL
# resource "aws_iam_policy" "lambda_firehose_network_telemetry_s3_etl" {
#   name   = "lambda-firehose-network-telemetry-s3-etl"
#   policy = data.aws_iam_policy_document.firehose_network_telemetry_invoke_lambda.json
# }
# # IAM Policy Data - Lambda S3 ETL
# data "aws_iam_policy_document" "lambda_firehose_network_telemetry_s3_etl" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:GetObject",
#       "s3:PutObject"
#     ]

#     resources = [
#       "arn:aws:s3:::aws-waf-logs-${local.env}-{local.bucket_suffix}/*"
#     ]
#   }
# }



# -------------------------------------------------------------------------------
# CloudWatc Logs Resource Policies
# -------------------------------------------------------------------------------

# Conditional IAM Policy Object - WAF Direct Log Delivery to CloudWatch
# When using count, Terraform trnasforms this resource into a LIST.
# The resource must be accessed by index:
# If count = 0, the resource does not exist and direct indexing will fail.
# Consider using try() to safely reference attributes when a resource is conditional.
# try(aws_cloudwatch_log_resource_policy.waf_direct[0].policy_name, null)
resource "aws_cloudwatch_log_resource_policy" "waf_direct" {
  count = var.enable_direct_service_log_delivery ? 1 : 0

  policy_name     = "waf-direct-delivery-policy"
  policy_document = data.aws_iam_policy_document.waf_direct[0].json
}
# Conditional IAM Policy Data - WAF Direct Log Delivery to CloudWatch
data "aws_iam_policy_document" "waf_direct" {
  count = local.waf_log_mode.create_direct_resources ? 1 : 0

  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.waf_logs[0].arn}:*"
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:logs:${local.region}:${local.account_id}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        tostring(local.account_id)
      ]
    }
  }
}