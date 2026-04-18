# ----------------------------------------------------------------
# OBSERVABILITY — Kinesis Firehose (Conditional)
# ----------------------------------------------------------------
# Kinesis Firehose – Network Telemetry
resource "aws_kinesis_firehose_delivery_stream" "network_telemetry" {
  count = local.waf_log_mode.create_firehose_resources ? 1 : 0

  name        = "aws-waf-logs-${local.env}-network-telemetry"
  destination = "extended_s3"


  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_network_telemetry_role[0].arn
    bucket_arn = aws_s3_bucket.waf_firehose_logs[0].arn
    prefix     = "waf-logs/"

    # ----------------------------------------------------------------
    # FIREHOSE — Buffering Configuration
    # ----------------------------------------------------------------
    # This small buffer is helpful in labs.
    # It forces Firehose to quickly flush records to S3.
    buffering_interval = 60 # Seconds
    buffering_size     = 1  # MB

    # ----------------------------------------------------------------
    # FIREHOSE — CloudWatch Delivery Logging (Optional)
    # ----------------------------------------------------------------
    # cloudwatch_logging_options {
    #   enabled         = true
    #   log_group_name  = aws_cloudwatch_log_group.waf_firehose_logs[0].name
    #   log_stream_name = "firehose-delivery"
    # }

    # ----------------------------------------------------------------
    # FIREHOSE — Lambda Transformation (Optional)
    # ----------------------------------------------------------------
    # Firehose No-Op Lambda. Chokes on S3 delivery. Likely due to permissions.
    # Processing configuration is commented out so Firehose functions properly.
    #
    # processing_configuration {
    #   enabled = true
    #
    #   processors {
    #     type = "Lambda"
    #
    #     parameters {
    #       parameter_name  = "LambdaArn"
    #       parameter_value = "${aws_lambda_function.lambda_firehose_network_telemetry_processor.arn}:$LATEST"
    #     }
    #   }
    # }
  }
}