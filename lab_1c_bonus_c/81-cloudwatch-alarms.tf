# CloudWatch Alarm - Public App to MySQL Connection Failure
# Metric
resource "aws_cloudwatch_log_metric_filter" "rds_app_to_lab_mysql_connection_failure" {
  name           = "public-app-to-lab-mysql-connection-failure"
  log_group_name = aws_cloudwatch_log_group.vpc_flow_log.name

  pattern = <<PATTERN
  [version, account_id, interface_id, srcaddr, dstaddr, srcport, dstport="3306", protocol, packets, bytes, start, end, action="REJECT", log_status]
  PATTERN 

  metric_transformation {
    name      = "RdsAppToLabMySqlConnectionFailure"
    namespace = "Custom/VPC"
    value     = "1"
  }
}
# Alarm
resource "aws_cloudwatch_metric_alarm" "rds_app_to_lab_mysql_connection_failure" {
  alarm_name          = "rds-app-to-lab-mysql-connection-failure"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RdsAppToLabMySqlConnectionFailure"
  namespace           = "Custom/VPC"
  period              = 60
  statistic           = "Sum"
  threshold           = 3

  alarm_description = "Triggers when EC2 to RDS REJECT traffic exceeds 6 in 2 minutes"
  alarm_actions     = [aws_sns_topic.app_to_rds_connection_failure_alert.arn]

  treat_missing_data = "notBreaching" # Alarm stays in OK state when CloudWatch has no data points (prevents noisy insufficient data state on error-count metrics)

  tags = {
    Name        = "app-to-lab-mysql-connection-failure"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "alarm-db"
    Scope       = "monitoring-connectivity"
    Severity    = "medium"
  }
}


# CloudWatch Alarm - LabMySQL Auth Failure
# Metric
resource "aws_cloudwatch_log_metric_filter" "lab_mysql_auth_failure" {
  name           = "lab-mysql-auth-failure"
  log_group_name = "/aws/rds/instance/${aws_db_instance.lab_mysql.identifier}/error" # RDS creates and manages this log group, so use a direct string reference (or a data source), not a Terraform resource.

  pattern = "Access denied for user"
  metric_transformation {
    name      = "MySQLAuthFailure"
    namespace = "Custom/RDS"
    value     = "1"
  }
}
# Alarm
resource "aws_cloudwatch_metric_alarm" "alarm_lab_mysql_auth_failure" {
  alarm_name          = "alarm-lab-mysql-auth-failure"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MySQLAuthFailure"
  namespace           = "Custom/RDS"
  period              = 60
  statistic           = "Sum"
  threshold           = 3

  alarm_description = "Triggers when MySQL db auth failures exceed 6 in 2 minutes"
  alarm_actions     = [aws_sns_topic.lab_mysql_auth_failure_alert.arn]

  treat_missing_data = "notBreaching" # Alarm stays in OK state when CloudWatch has no data points (prevents noisy insufficient data state on error-count metrics)

  tags = {
    Name        = "alarm-lab-mysql-auth-failures"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "alarm-db"
    Scope       = "monitoring-login"
    Severity    = "medium"
  }
}

# CloudWatch Alarm - RDS App ALB Server Error

# Metric

resource "aws_cloudwatch_log_metric_filter" "rds_app_alb_server_error" {
  name           = "rds-app-alb-server"
  log_group_name = aws_cloudwatch_log_group.rds_app_alb_server_error.name

  pattern = <<PATTERN
  [type, time, elb, client_port, target_port, request_processing_time, response_processing_time, elb_status_code="5$${*}", target_status_code, received_bytes, sent_bytes, request_line, user_agent, ssl_cipher, ssl_protocol, target_group_arn, trace_id, domain_name, chosen_cert_arn, matched_rule_priority, request_creation_time, actions_executed, redirect_url, error_reason, target_port_list, target_status_code_list, classification, classification_reason, conn_trace_id, transformed_host, transformed_uri, request_transform_status]
  PATTERN

  metric_transformation {
    name      = "RdsAppAlbServerError"
    namespace = "Custom/VPC"
    value     = "1"
  }
}

# Alarm - ALB 5xx Error Rate for RDS App
resource "aws_cloudwatch_metric_alarm" "rds_app_alb_server_error_alarm" {
  alarm_name          = "rds-app-alb-server-error"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RdsAppAlbServerError"
  namespace           = "Custom/VPC"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  alarm_description = "Triggers when RDS App ALB returns 5 or more server errors in 2 minutes"
  alarm_actions     = [aws_sns_topic.rds_app_alb_server_error_alert.arn]

  treat_missing_data = "notBreaching" # Alarm stays in OK state when CloudWatch has no data points (prevents noisy insufficient data state on error-count metrics)

  tags = {
    Name        = "rds-app-alb-server-error"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "alarm-alb"
    Scope       = "monitoring-backend"
    Severity    = "high"
  }
}