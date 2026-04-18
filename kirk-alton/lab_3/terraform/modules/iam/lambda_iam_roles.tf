# ----------------------------------------------------------------
# IAM — Lambda Roles (Firehose Network Telemetry Processor)
# ----------------------------------------------------------------

# # IAM Role - Lambda Network Telemetry Role
# resource "aws_iam_role" "lambda_firehose_network_telemetry_processor_role" {
#   provider = aws.regional
#   name               = "lambda-firehose-network-telemetry-processor-role"
#   assume_role_policy = data.aws_iam_policy_document.lambda_firehose_network_telemetry_processor_assume_role.json
#
#   tags = merge(
#     {
#       Name      = "lambda-firehose-network-telemetry-role"
#       Component = "iam"
#     },
#     var.context.tags
#   )
# }

# ----------------------------------------------------------------
# IAM — Trust Policies (Lambda Service)
# ----------------------------------------------------------------

# # Trust Policy Data -Lambda Firehose Network Telemetry Role
# data "aws_iam_policy_document" "lambda_firehose_network_telemetry_processor_assume_role" {
#   provider = aws.regional
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
#   provider = aws.regional
#   role       = aws_iam_role.lambda_firehose_network_telemetry_processor_role.id
#   policy_arn = aws_iam_policy.lambda_firehose_network_telemetry_logs.arn
# }

# # Policy Attachment - Lambda Firehose Network Telemetry S3 ETL --> Lambda Firehose Network Telemetry Role
# resource "aws_iam_role_policy_attachment" "attach_lambda_firehose_network_telemetry_s3_etl" {
#   role       = aws_iam_role.lambda_firehose_network_telemetry_processor_role.id
#   policy_arn = aws_iam_policy.lambda_firehose_network_telemetry_s3_etl.arn
# }