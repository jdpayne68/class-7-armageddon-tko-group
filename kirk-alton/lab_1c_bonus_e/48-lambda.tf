# TODO: Need to create Lambda function code to detect S3 PUT event for ALB logs and write data to CloudWatch Logs to track ALB server errors.

# Lambda Function - Firehose Network Telemetry Processor
resource "aws_lambda_function" "lambda_firehose_network_telemetry_processor" {
  filename         = data.archive_file.lambda_firehose_processor.output_path
  source_code_hash = data.archive_file.lambda_firehose_processor.output_base64sha256

  function_name = "firehose-network-telemetry-processor"
  role          = aws_iam_role.lambda_firehose_network_telemetry_processor_role.arn

  handler = "firehose_processor.handler"
  runtime = "python3.12"
}

# Zip Archive - Lambda Firehose Processor
data "archive_file" "lambda_firehose_processor" {
  type        = "zip"
  source_file = "${path.module}/lambda-code/firehose-processor.py"
  output_path = "${path.module}/lambda-code/firehose-processor.zip"
}

# NOTE: This Lambda is an intentional no-op Firehose processor that at preserves the delivery pipeline architecture.
# The code is minimal, and the function can be expanded in the future without architectural changes.


# Lambda Permission - Firehose Invoke
resource "aws_lambda_permission" "allow_firehose_invoke" {
  statement_id  = "AllowFirehoseInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_firehose_network_telemetry_processor.function_name
  principal     = "firehose.amazonaws.com"

  source_arn = aws_kinesis_firehose_delivery_stream.network_telemetry.arn
}