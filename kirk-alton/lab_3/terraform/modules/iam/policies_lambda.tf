# ----------------------------------------------------------------
# IAM — Policies (Lambda Logging)
# ----------------------------------------------------------------

# IAM Policy Object - Lambda Firehose Network Telemetry Logs
resource "aws_iam_policy" "lambda_firehose_network_telemetry_logs" {
  provider = aws.regional

  name   = "lambda-firehose-network-telemetry-logs"
  policy = data.aws_iam_policy_document.lambda_firehose_network_telemetry_logs.json

  tags = merge(
    {
      Name      = "lambda-firehose-network-telemetry-logs-policy"
      Component = "iam"
    },
    var.context.tags
  )
}

# IAM Policy Data - Lambda Firehose Network Telemetry Logs
data "aws_iam_policy_document" "lambda_firehose_network_telemetry_logs" {
  provider = aws.regional

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

# ----------------------------------------------------------------
# IAM — Policies (Lambda S3 ETL) [Optional / Future]
# ----------------------------------------------------------------

# # IAM Policy Object - Lambda S3 ETL
# resource "aws_iam_policy" "lambda_firehose_network_telemetry_s3_etl" {
#   name   = "lambda-firehose-network-telemetry-s3-etl"
#   policy = data.aws_iam_policy_document.firehose_network_telemetry_invoke_lambda.json
# }

# # IAM Policy Data - Lambda S3 ETL
# data "aws_iam_policy_document" "lambda_firehose_network_telemetry_s3_etl" {
#   statement {
#     effect = "Allow"
#
#     actions = [
#       "s3:GetObject",
#       "s3:PutObject"
#     ]
#
#     resources = [
#       "arn:aws:s3:::aws-waf-logs-${var.context.env}-{var.bucket_suffix}/*"
#     ]
#   }
# }