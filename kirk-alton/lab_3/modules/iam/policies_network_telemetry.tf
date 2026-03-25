# ----------------------------------------------------------------
# IAM — Policies (Network Telemetry / Firehose)
# ----------------------------------------------------------------

# IAM Policy Object - Firehose Network Telemetry Logs
resource "aws_iam_policy" "firehose_network_telemetry_logs" {
  provider = aws.regional

  count = var.waf_log_mode.create_firehose_resources ? 1 : 0

  name   = "firehose-network-telemetry-logs"
  policy = data.aws_iam_policy_document.firehose_network_telemetry_logs[0].json

  tags = merge(
    {
      Name      = "firehose-network-telemetry-logs-policy"
      Component = "iam"
    },
    var.context.tags
  )
}

# Conditional IAM Policy Data - Firehose Network Telemetry Logs
data "aws_iam_policy_document" "firehose_network_telemetry_logs" {
  provider = aws.regional

  count = var.waf_log_mode.create_firehose_resources ? 1 : 0

  # Allow Firehose to write diagnostic logs to CloudWatch
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${var.waf_firehose_log_group_arn}:*"
    ]
  }

  # Bucket-level permissions
  statement {
    sid       = "FirehoseBucketMetadata"
    actions   = ["s3:GetBucketLocation", "s3:ListBucket"]
    resources = [var.waf_firehose_log_bucket_arn]
  }

  # Object-level permissions
  statement {
    sid       = "FirehoseObjectWrite"
    actions   = ["s3:PutObject", "s3:AbortMultipartUpload"]
    resources = ["${var.waf_firehose_log_bucket_arn}/*"]
  }
}

# ----------------------------------------------------------------
# IAM — Policies (Network Telemetry Lambda Integration) [Optional]
# ----------------------------------------------------------------

# # IAM Policy Object - Firehose Network Telemetry Invoke Lambda
# resource "aws_iam_policy" "firehose_network_telemetry_invoke_lambda" {
#   name   = "firehose-network-telemetry-invoke-lambda"
#   policy = data.aws_iam_policy_document.firehose_network_telemetry_invoke_lambda.json
# }

# # IAM Policy Data - Firehose Network Telemetry Invoke Lambda
# data "aws_iam_policy_document" "firehose_network_telemetry_invoke_lambda" {
#   statement {
#     effect = "Allow"
#
#     actions = [
#       "lambda:InvokeFunction"
#     ]
#
#     resources = [
#       aws_lambda_function.lambda_firehose_network_telemetry_processor.arn
#     ]
#   }
# }