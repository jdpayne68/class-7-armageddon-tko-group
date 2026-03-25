# ----------------------------------------------------------------
# IAM — Lambda Firehose Network Telemetry Role (Optional / Future)
# ----------------------------------------------------------------

# # IAM Role - Lambda Network Telemetry Role
# resource "aws_iam_role" "lambda_firehose_network_telemetry_processor_role" {
#   name               = "lambda-firehose-network-telemetry-processor-role"
#   assume_role_policy = data.aws_iam_policy_document.lambda_firehose_network_telemetry_processor_assume_role.json
# }

# ----------------------------------------------------------------
# IAM — Trust Policy (Lambda Service)
# ----------------------------------------------------------------

# # Trust Policy Data -Lambda Firehose Network Telemetry Role
# data "aws_iam_policy_document" "lambda_firehose_network_telemetry_processor_assume_role" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#
#     actions = ["sts:AssumeRole"]
#   }
# }

# ----------------------------------------------------------------
# IAM — Role Policy Attachments (Lambda Processor)
# ----------------------------------------------------------------

# # Policy Attachment - Lambda Firehose Network Telemetry Logs --> Lambda Firehose Network Telemetry Role
# resource "aws_iam_role_policy_attachment" "attach_lambda_firehose_network_telemetry_logs" {
#   role       = aws_iam_role.lambda_firehose_network_telemetry_processor_role.id
#   policy_arn = aws_iam_policy.lambda_firehose_network_telemetry_logs.arn
# }

# # Policy Attachment - Lambda Firehose Network Telemetry S3 ETL --> Lambda Firehose Network Telemetry Role
# resource "aws_iam_role_policy_attachment" "attach_lambda_firehose_network_telemetry_s3_etl" {
#   role       = aws_iam_role.lambda_firehose_network_telemetry_processor_role.id
#   policy_arn = aws_iam_policy.lambda_firehose_network_telemetry_s3_etl.arn
# }
