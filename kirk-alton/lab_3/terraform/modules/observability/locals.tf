# ----------------------------------------------------------------
# OBSERVABILITY — Locals
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # WAF Log Destination Resolution
  # ----------------------------------------------------------------

  # Resolve WAF log destination ARN.
  # Kept separate from waf_log_mode to avoid dependency cycles.

  waf_log_destination_arn = (
    var.waf_log_mode.target == "cloudwatch" ? aws_cloudwatch_log_group.waf_logs[0].arn :
    var.waf_log_mode.target == "firehose" ? aws_kinesis_firehose_delivery_stream.network_telemetry[0].arn :
    var.waf_log_mode.target == "s3" ? aws_s3_bucket.waf_logs_bucket[0].arn :
    error("Invalid WAF log destination target.")
  )

  # ----------------------------------------------------------------
# OBSERVABILITY — Conditional WAF Dashboard Widget (CloudFront)
# ----------------------------------------------------------------

waf_widget = var.rds_app_waf_name != null ? [
  {
    type   = "metric"
    x      = 0
    y      = 12
    width  = 24
    height = 6

    properties = {
      title = "CloudFront WAF Blocked Requests"

      metrics = [
        [
          "AWS/WAFV2",
          "BlockedRequests",
          "WebACL", var.rds_app_waf_name,
          "Region", "Global",
          "Rule", "ALL"
        ]
      ]

      region = "us-east-1"
      period = 300
      view   = "timeSeries"
    }
  }
] : []

  # Ternary operator syntax:
  # condition ? value_if_true : value_if_false
  #
  # Everything inside the expression must evaluate to ONE value.

  # ----------------------------------------------------------------
  # OBSERVABILITY — Conditional WAF Dashboard Widget (CloudFront)
  # ----------------------------------------------------------------
  # This widget is only rendered when a WAF Web ACL name is provided.
  # CloudWatch dashboards require valid string metric dimensions, and
  # do not accept null or empty values. When WAF is disabled in the
  # regional stack, var.rds_app_waf_name will be null, so the widget
  # must be omitted entirely to avoid dashboard validation errors.
  #
  # Pattern:
  #   If WAF exists  → include widget
  #   If WAF absent  → return empty list
  # ----------------------------------------------------------------

  # waf_widget = var.rds_app_waf_name != null ? [
  #   {
  #     type   = "metric"
  #     x      = 0
  #     y      = 6
  #     width  = 8
  #     height = 6

  #     properties = {
  #       title = "CloudFront WAF Blocked Requests"

  #       metrics = [
  #         [
  #           "AWS/WAFV2",
  #           "BlockedRequests",
  #           "WebACL", var.rds_app_waf_name,
  #           "Region", "Global",
  #           "Rule", "ALL"
  #         ]
  #       ]

  #       region = "us-east-1"
  #       period = 300
  #       view   = "timeSeries"
  #     }
  #   }
  # ] : []
}

