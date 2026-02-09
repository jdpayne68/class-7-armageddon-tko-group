# IAM Role - Firehose Network Telemetry Role
resource "aws_iam_role" "firehose_network_telemetry_role" {
  name               = "firehose_network_telemetry_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_network_telemetry_assume_role.json
}


# Trust Policy Data - Firehose Network Telemetry Assume Role Policy
data "aws_iam_policy_document" "firehose_network_telemetry_assume_role" {
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
  role       = aws_iam_role.firehose_network_telemetry_role.id
  policy_arn = aws_iam_policy.firehose_network_telemetry_logs.arn
}


# Policy Attachment - Firehose Network Telemetry Invoke Lambda Policy --> Firehose Network Telemetry Role
resource "aws_iam_role_policy_attachment" "attach_firehose_network_telemetry_invoke_lambda" {
  role       = aws_iam_role.firehose_network_telemetry_role.id
  policy_arn = aws_iam_policy.firehose_network_telemetry_invoke_lambda.arn
}