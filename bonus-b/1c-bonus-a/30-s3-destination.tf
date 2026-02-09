############################################
# Option 2: S3 destination (direct)
############################################

# Explanation: S3 WAF logs are the long-term archive—Chewbacca likes receipts that survive dashboards.
resource "aws_s3_bucket" "armageddon_waf_logs_bucket01" {
  count = var.waf_log_destination == "s3" ? 1 : 0

  bucket = "aws-waf-logs-${var.project_name}-${data.aws_caller_identity.armageddon_self01.account_id}"

  tags = {
    Name = "${var.project_name}-waf-logs-bucket01"
  }
}

# Explanation: Public access blocked—WAF logs are not a bedtime story for the entire internet.
resource "aws_s3_bucket_public_access_block" "armageddon_waf_logs_pab01" {
  count = var.waf_log_destination == "s3" ? 1 : 0

  bucket                  = aws_s3_bucket.armageddon_waf_logs_bucket01[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Explanation: Connect shield generator to archive vault—WAF -> S3.
resource "aws_wafv2_web_acl_logging_configuration" "armageddon_waf_logging_s3_01" {
  count = var.enable_waf && var.waf_log_destination == "s3" ? 1 : 0

  resource_arn = aws_wafv2_web_acl.armageddon_waf01[0].arn
  log_destination_configs = [
    aws_s3_bucket.armageddon_waf_logs_bucket01[0].arn
  ]

  depends_on = [aws_wafv2_web_acl.armageddon_waf01]
}
