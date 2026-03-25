# ----------------------------------------------------------------
# IAM — CloudWatch Logs Resource Policies (Service Delivery)
# ----------------------------------------------------------------

# Conditional IAM Policy Object - WAF Direct Log Delivery to CloudWatch
# When using count, Terraform transforms this resource into a LIST.
# The resource must be accessed by index:
# If count = 0, the resource does not exist and direct indexing will fail.
# Consider using try() to safely reference attributes when a resource is conditional.
# try(aws_cloudwatch_log_resource_policy.waf_direct[0].policy_name, null)
resource "aws_cloudwatch_log_resource_policy" "waf_direct" {
  provider = aws.regional

  count = var.enable_direct_service_log_delivery ? 1 : 0

  policy_name     = "waf-direct-delivery-policy"
  policy_document = data.aws_iam_policy_document.waf_direct[0].json
}

# Conditional IAM Policy Data - WAF Direct Log Delivery to CloudWatch
data "aws_iam_policy_document" "waf_direct" {
  provider = aws.regional

  count = var.waf_log_mode.create_direct_resources ? 1 : 0

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
      "${var.waf_direct_log_group_arn}:*"
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