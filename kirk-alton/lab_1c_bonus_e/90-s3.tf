# Terraform Managed S3 Bucket - Terraform Bucket
resource "aws_s3_bucket" "alb_logs_bucket" {
  bucket = "alb-logs-${local.region}-${local.bucket_suffix}"

  force_destroy = true

  tags = {
    Name        = "alb-logs-bucket"
    Component   = "storage"
    DataClass   = "confidential"
    Environment = "${local.env}"
  }
}
# Server Side Encryption - Terraform Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs_bucket" {
  bucket = aws_s3_bucket.alb_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Conditional Terraform Managed S3 Bucket - AWS WAF Logs
resource "aws_s3_bucket" "waf_logs_bucket" {
  count = local.waf_log_mode.direct ? 1 : 0 # Remember to use index when referencing a conditional resource

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
  count  = local.waf_log_mode.direct ? 1 : 0
  bucket = aws_s3_bucket.waf_logs_bucket[0].id # Index is required for reference to a conditional resource

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Terraform Managed S3 Bucket - WAF Firehose Logs
resource "aws_s3_bucket" "waf_firehose_logs" {
  bucket        = "aws-waf-logs-${local.env}-network-telemetry-${local.bucket_suffix}"
  force_destroy = true

    tags = {
    Name        = "waf-logs-network-telemetry"
    Component   = "storage"
    DataClass   = "confidential"
    Environment = "${local.env}"
  }
}
# Server Side Encryption - Terraform Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "waf_firehose_logs" {
  bucket = aws_s3_bucket.alb_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# WAF Firehose Logs Bucket Policy Object
resource "aws_s3_bucket_policy" "waf_firehose_logs" {
  bucket = aws_s3_bucket.waf_firehose_logs.id
  policy = data.aws_iam_policy_document.waf_firehose_logs_bucket_policy.json
}

# WAF Firehose Logs Bucket Policy Data
data "aws_iam_policy_document" "waf_firehose_logs_bucket_policy" {
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
      aws_s3_bucket.waf_firehose_logs.arn,
      "${aws_s3_bucket.waf_firehose_logs.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
  }
}
