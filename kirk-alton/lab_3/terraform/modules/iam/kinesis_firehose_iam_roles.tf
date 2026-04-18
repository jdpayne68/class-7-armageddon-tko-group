# ----------------------------------------------------------------
# IAM — Roles (Firehose Network Telemetry)
# ----------------------------------------------------------------

# IAM Role - Firehose Network Telemetry Role
resource "aws_iam_role" "firehose_network_telemetry_role" {
  provider = aws.regional

  count              = var.waf_log_mode.create_firehose_resources ? 1 : 0
  name               = "firehose-network-telemetry-role-${var.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.firehose_network_telemetry_assume_role[0].json

  tags = merge(
    {
      Name      = "firehose-network-telemetry-role"
      Component = "iam"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# IAM — Trust Policies (Firehose Service)
# ----------------------------------------------------------------

# Trust Policy Data - Firehose Network Telemetry Assume Role Policy
data "aws_iam_policy_document" "firehose_network_telemetry_assume_role" {
  provider = aws.regional

  count = var.waf_log_mode.create_firehose_resources ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# ----------------------------------------------------------------
# IAM — Role Policy Attachments (Firehose)
# ----------------------------------------------------------------

# Policy Attachment - Firehose Network Telemetry Logs Policy --> Firehose Network Telemetry Role
resource "aws_iam_role_policy_attachment" "attach_firehose_network_telemetry_logs" {
  provider = aws.regional

  count = var.waf_log_mode.create_firehose_resources ? 1 : 0

  role       = aws_iam_role.firehose_network_telemetry_role[0].id
  policy_arn = aws_iam_policy.firehose_network_telemetry_logs[0].arn
}

# # Policy Attachment - Firehose Network Telemetry Invoke Lambda Policy --> Firehose Network Telemetry Role
# resource "aws_iam_role_policy_attachment" "attach_firehose_network_telemetry_invoke_lambda" {
#   role       = aws_iam_role.firehose_network_telemetry_role.id
#   policy_arn = aws_iam_policy.firehose_network_telemetry_invoke_lambda.arn
# }