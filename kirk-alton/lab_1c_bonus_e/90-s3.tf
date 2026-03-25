# -------------------------------------------------------------------------------
# ALB Logs Bucket, Policies & Permissions
# -------------------------------------------------------------------------------

# Conditional Terraform Managed S3 Bucket - ALB Logs
resource "aws_s3_bucket" "alb_logs_bucket" {
  count = local.alb_log_mode ? 1 : 0

  bucket = "alb-logs-${local.region}-${local.bucket_suffix}"

  force_destroy = true

  tags = {
    Name        = "alb-logs-bucket"
    Component   = "storage"
    DataClass   = "confidential"
    Environment = "${local.env}"
  }
}
# Conditional Server Side Encryption - ALB Logs
resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs_bucket" {
  count  = local.alb_log_mode ? 1 : 0
  bucket = aws_s3_bucket.alb_logs_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# S3 Bucket Policy Object - ALB Logs
resource "aws_s3_bucket_policy" "rds_app_alb_logs" {
  count = local.alb_log_mode ? 1 : 0

  bucket = aws_s3_bucket.alb_logs_bucket[0].id
  policy = data.aws_iam_policy_document.rds_app_alb_logs[0].json
}
# S3 Bucket Policy Data - ALB Logs
data "aws_iam_policy_document" "rds_app_alb_logs" {
  count = local.alb_log_mode ? 1 : 0
  statement {
    sid    = "AllowWritesToRdsAppAlbLogs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = ["${aws_s3_bucket.alb_logs_bucket[0].arn}/${var.alb_access_logs_prefix}/*"] # Policy determined by the value of the variable.
  }
}


# -------------------------------------------------------------------------------
# WAF Logs Bucket, Policies & Permissions
# -------------------------------------------------------------------------------

# Conditional Terraform Managed S3 Bucket - AWS WAF Logs
resource "aws_s3_bucket" "waf_logs_bucket" {
  count = local.waf_log_mode.create_direct_resources ? 1 : 0 # Remember to use index when referencing a conditional resource

  bucket = "aws-waf-logs-terraform-managed-bucket-${local.region}-${local.bucket_suffix}"

  force_destroy = true

  tags = {
    Name        = "aws-waf-logs-terraform-managed-bucket"
    Component   = "storage"
    DataClass   = "confidential"
    Environment = "${local.env}"
  }
}
# Conditional Server Side Encryption - AWS WAF Logs Bucket (Conditional)
resource "aws_s3_bucket_server_side_encryption_configuration" "waf_logs_bucket" {
  count  = local.waf_log_mode.create_direct_resources ? 1 : 0
  bucket = aws_s3_bucket.waf_logs_bucket[0].id # Index is required for reference to a conditional resource

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -------------------------------------------------------------------------------
# WAF Firehose Logs Bucket, Policies & Permissions
# -------------------------------------------------------------------------------

# Conditional Terraform Manged S3 Bucket - WAF Firehose Logs
resource "aws_s3_bucket" "waf_firehose_logs" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0
  
  bucket = "aws-waf-logs-firehose-${local.region}-${local.bucket_suffix}"
  force_destroy = true

}

# Conditional Server Side Encryption - WAF Firehose Logs Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "waf_firehose_logs" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0

  bucket = aws_s3_bucket.waf_firehose_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Conditional WAF Firehose Logs Bucket Policy Object
resource "aws_s3_bucket_policy" "waf_firehose_logs" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0

  bucket = aws_s3_bucket.waf_firehose_logs[0].id
  policy = data.aws_iam_policy_document.waf_firehose_logs_bucket_policy[0].json
}


# WAF Firehose Logs Bucket Policy Data

data "aws_iam_policy_document" "waf_firehose_logs_bucket_policy" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0
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
      values   = [local.account_id]
    }
  }
}
