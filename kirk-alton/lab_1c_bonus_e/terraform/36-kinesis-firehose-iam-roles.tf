# IAM Role - Firehose Network Telemetry Role
resource "aws_iam_role" "firehose_network_telemetry_role" {
  count              = local.waf_log_mode.create_firehose_resources ? 1 : 0
  name               = "firehose_network_telemetry_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_network_telemetry_assume_role[0].json
}


# Trust Policy Data - Firehose Network Telemetry Assume Role Policy
data "aws_iam_policy_document" "firehose_network_telemetry_assume_role" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Policy Attachment - Firehose Network Telemetry Logs Policy --> Firehose Network Telemetry Role
resource "aws_iam_role_policy_attachment" "attach_firehose_network_telemetry_logs" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0

  role       = aws_iam_role.firehose_network_telemetry_role[0].id
  policy_arn = aws_iam_policy.firehose_network_telemetry_logs[0].arn #  attribute is count 1 on the resource (second item in the list)
}


# # Policy Attachment - Firehose Network Telemetry Invoke Lambda Policy --> Firehose Network Telemetry Role
# resource "aws_iam_role_policy_attachment" "attach_firehose_network_telemetry_invoke_lambda" {
#   role       = aws_iam_role.firehose_network_telemetry_role.id
#   policy_arn = aws_iam_policy.firehose_network_telemetry_invoke_lambda.arn
# }