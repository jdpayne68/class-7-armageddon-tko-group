# Conditional WAF Logging - Direct (CloudWatch or S3)
# When using count, Terraform trnasforms this resource into a LIST.
# The resource must be accessed by index:
# If count = 0, the resource does not exist and direct indexing will fail.
# Consider using try() to safely reference attributes when a resource is conditional.
# try(aws_wafv2_web_acl_logging_configuration.rds_app_waf_direct[0].arn, null)
resource "aws_wafv2_web_acl_logging_configuration" "rds_app_waf_direct" {
  count = local.waf_log_mode.direct ? 1 : 0

  resource_arn = aws_wafv2_web_acl.rds_app.arn

  log_destination_configs = [
    local.waf_log_destination_arn
  ]
}


# Conditional WAF Logging - Firehose
resource "aws_wafv2_web_acl_logging_configuration" "rds_app_waf_firehose" {
  count = local.waf_log_mode.use_firehose ? 1 : 0

  resource_arn = aws_wafv2_web_acl.rds_app.arn

  log_destination_configs = [
    local.waf_log_destination_arn
  ]
}
