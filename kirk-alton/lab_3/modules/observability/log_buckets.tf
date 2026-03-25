# ----------------------------------------------------------------
# STORAGE — ALB Access Logs (S3 + Policy)
# ----------------------------------------------------------------

# Conditional Terraform Managed S3 Bucket - ALB Logs
resource "aws_s3_bucket" "alb_logs_bucket" {
  provider = aws.regional

  count = var.alb_log_s3 ? 1 : 0

  bucket        = "alb-logs-${var.context.region}-${var.bucket_suffix}"
  force_destroy = true

  tags = {
    Name        = "alb-logs-bucket"
    Component   = "storage"
    DataClass   = "confidential"
    Environment = var.context.env
  }
}

# Conditional Server-Side Encryption - ALB Logs
resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs_bucket" {
  provider = aws.regional

  count  = var.alb_log_s3 ? 1 : 0
  bucket = aws_s3_bucket.alb_logs_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Policy Object - ALB Logs
resource "aws_s3_bucket_policy" "rds_app_alb_logs" {
  provider = aws.regional

  count = var.alb_log_s3 ? 1 : 0

  bucket = aws_s3_bucket.alb_logs_bucket[0].id
  policy = data.aws_iam_policy_document.rds_app_alb_logs[0].json
}

# S3 Bucket Policy Data - ALB Logs
data "aws_iam_policy_document" "rds_app_alb_logs" {
  provider = aws.regional

  count = var.alb_log_s3 ? 1 : 0

  statement {
    sid    = "AllowALBAccessLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.alb_logs_bucket[0].arn}/${var.alb_access_logs_prefix}/*"
    ]
  }
}

# ----------------------------------------------------------------
# STORAGE — WAF Direct Logs (S3 + Policy)
# ----------------------------------------------------------------

# Conditional Terraform Managed S3 Bucket - WAF Logs
resource "aws_s3_bucket" "waf_logs_bucket" {
  provider = aws.regional

  count         = var.waf_log_mode.create_direct_resources ? 1 : 0
  bucket        = "aws-waf-logs-${var.context.region}-${var.bucket_suffix}"
  force_destroy = true

  tags = {
    Name        = "aws-waf-logs-terraform-managed-bucket"
    Component   = "storage"
    DataClass   = "confidential"
    Environment = var.context.env
  }
}

# Conditional Server-Side Encryption - WAF Logs
resource "aws_s3_bucket_server_side_encryption_configuration" "waf_logs_bucket" {
  provider = aws.regional

  count  = var.waf_log_mode.create_direct_resources ? 1 : 0
  bucket = aws_s3_bucket.waf_logs_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# # WAF Logs Bucket Policy Object
# resource "aws_s3_bucket_policy" "waf_logs_bucket" {
#   provider = aws.regional

#   count = var.waf_log_mode.create_direct_resources ? 1 : 0

#   bucket = aws_s3_bucket.waf_logs_bucket[0].id
#   policy = data.aws_iam_policy_document.waf_logs_bucket_policy[0].json
# }

# # WAF Logs Bucket Policy Data
# data "aws_iam_policy_document" "waf_logs_bucket_policy" {
#   provider = aws.regional

#   count = var.waf_log_mode.create_direct_resources ? 1 : 0
#   statement {
#     sid    = "AllowWafDirectWrite"
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["delivery.logs.amazonaws.com"]
#     }

#     actions = [
#       "s3:PutObject"
#       # Some regions may require s3:GetBucketAcl during validation
#     ]

#     resources = [
#       "${aws_s3_bucket.waf_logs_bucket[0].arn}/*"
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceAccount"
#       values   = [var.account_id]
#     }

#     condition {
#       test     = "ArnLike"
#       variable = "aws:SourceArn"
#       values   = [var.rds_app_waf_arn]
#     }
#   }
# }

# ----------------------------------------------------------------
# STORAGE — WAF Firehose Logs (S3 + Policy)
# ----------------------------------------------------------------

# Conditional Terraform Managed S3 Bucket - WAF Firehose Logs
resource "aws_s3_bucket" "waf_firehose_logs" {
  provider = aws.regional

  count = var.waf_log_mode.create_firehose_resources ? 1 : 0

  bucket        = "aws-waf-logs-firehose-${var.context.region}-${var.bucket_suffix}"
  force_destroy = true
}

# Conditional Server-Side Encryption - WAF Firehose Logs
resource "aws_s3_bucket_server_side_encryption_configuration" "waf_firehose_logs" {
  provider = aws.regional

  count  = var.waf_log_mode.create_firehose_resources ? 1 : 0
  bucket = aws_s3_bucket.waf_firehose_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Conditional WAF Firehose Logs Bucket Policy
resource "aws_s3_bucket_policy" "waf_firehose_logs" {
  provider = aws.regional

  count = var.waf_log_mode.create_firehose_resources ? 1 : 0

  bucket = aws_s3_bucket.waf_firehose_logs[0].id
  policy = data.aws_iam_policy_document.waf_firehose_log_bucket_policy[0].json
}

# WAF Firehose Logs Bucket Policy Data
data "aws_iam_policy_document" "waf_firehose_log_bucket_policy" {
  provider = aws.regional

  count = var.waf_log_mode.create_firehose_resources ? 1 : 0

  statement {
    sid    = "AllowFirehoseWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.waf_firehose_logs[0].arn,
      "${aws_s3_bucket.waf_firehose_logs[0].arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
  }
}