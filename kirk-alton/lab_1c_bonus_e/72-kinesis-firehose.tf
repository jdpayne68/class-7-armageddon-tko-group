# Kinesis Firehose – Network Telemetry
# Intentionally provisioned for future expansion (WAF, ALB, other producers).
# No cost incurred until data is ingested.
resource "aws_kinesis_firehose_delivery_stream" "network_telemetry" {
  name        = "aws-waf-logs-${local.env}-network-telemetry"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_network_telemetry_role.arn
    bucket_arn = aws_s3_bucket.waf_firehose_logs.arn
    prefix     = "waf-logs/"

    # Buffering Configuration
    # This small buffer is helpful in labs.
    # It forces Firehose to quickly flush records to S3.
    buffering_interval = 60 # Seconds
    buffering_size     = 1  # MB

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.waf_logs.name
      log_stream_name = "firehose-delivery"
    }

    processing_configuration {
      enabled = true

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.lambda_firehose_network_telemetry_processor.arn}:$LATEST"
        }
      }
    }
  }
}