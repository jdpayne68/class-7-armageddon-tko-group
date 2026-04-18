# ----------------------------------------------------------------
# SECURITY — WAF Logging Configuration (Direct Delivery)
# ----------------------------------------------------------------

resource "aws_wafv2_web_acl_logging_configuration" "rds_app_waf_direct" {
  provider = aws.regional

  count = var.create_waf && var.waf_log_mode.create_direct_resources ? 1 : 0

  resource_arn = aws_wafv2_web_acl.rds_app[0].arn

  log_destination_configs = [
    var.waf_log_destination_arn
  ]
}

# When using count, Terraform transforms this resource into a LIST.
# The resource must be accessed by index:
# If count = 0, the resource does not exist and direct indexing will fail.
# Consider using try() to safely reference attributes when a resource is conditional.
# try(aws_wafv2_web_acl_logging_configuration.rds_app_waf_direct[0].arn, null)

# ----------------------------------------------------------------
# SECURITY — WAF Logging Configuration (Firehose Delivery)
# ----------------------------------------------------------------

resource "aws_wafv2_web_acl_logging_configuration" "rds_app_waf_firehose" {
  provider = aws.regional

  count = var.create_waf && var.waf_log_mode.create_firehose_resources ? 1 : 0

  resource_arn = aws_wafv2_web_acl.rds_app[0].arn

  log_destination_configs = [
    var.waf_log_destination_arn
  ]
}

# ----------------------------------------------------------------
# SECURITY — WAF Logging Configuration (Bucket Policy)
# ----------------------------------------------------------------

# WAF Logs Bucket Policy Object
resource "aws_s3_bucket_policy" "waf_logs_bucket" {
  provider = aws.regional

  count = var.create_waf && var.waf_log_mode.create_direct_resources ? 1 : 0

  bucket = var.waf_log_bucket_id
  policy = data.aws_iam_policy_document.waf_logs_bucket_policy[0].json
}

# WAF Logs Bucket Policy Data
data "aws_iam_policy_document" "waf_logs_bucket_policy" {
  provider = aws.regional

  count = var.create_waf && var.waf_log_mode.create_direct_resources ? 1 : 0

  statement {
    sid    = "AllowWafDirectWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
      # Some regions may require s3:GetBucketAcl during validation
    ]

    resources = [
      "${var.waf_log_bucket_arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_wafv2_web_acl.rds_app[0].arn]
    }
  }
}