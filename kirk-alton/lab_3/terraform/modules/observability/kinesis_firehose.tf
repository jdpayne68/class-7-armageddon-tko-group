# ----------------------------------------------------------------
# OBSERVABILITY — Firehose (Network Telemetry)
# ----------------------------------------------------------------

# Kinesis Firehose - Network Telemetry
resource "aws_kinesis_firehose_delivery_stream" "network_telemetry" {
  provider = aws.regional

  count = var.waf_log_mode.create_firehose_resources ? 1 : 0

  name        = "aws-waf-logs-${var.context.env}-network-telemetry"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = var.firehose_network_telemetry_role_arn
    bucket_arn = aws_s3_bucket.waf_firehose_logs[0].arn
    prefix     = "waf-logs/"

    # ----------------------------------------------------------------
    # FIREHOSE — Buffering Configuration
    # ----------------------------------------------------------------
    # Smaller buffers are useful in labs so records flush quickly.
    buffering_interval = 60 # seconds
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
    # Example processing stage for ETL or enrichment.
    # Disabled here due to S3 delivery permission issues.
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