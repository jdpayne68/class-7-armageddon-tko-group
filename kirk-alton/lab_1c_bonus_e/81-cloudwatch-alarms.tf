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
    App         = "${local.app}"
    Environment = "${local.env}"
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
    App         = "${local.app}"
    Environment = "${local.env}"
    Component   = "alarm-db"
    Scope       = "monitoring-login"
    Severity    = "medium"
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
    App         = "${local.app}"
    Environment = "${local.env}"
    Component   = "alarm-alb"
    Scope       = "monitoring-backend"
    Severity    = "high"
  }
}





resource "aws_cloudwatch_metric_alarm" "rds_app_alb_target_5xx_alarm" {
  alarm_name          = "rds-app-alb-target-5xx"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 2
  period             = 60
  threshold          = 5
  statistic          = "Sum"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"

  dimensions = {
    LoadBalancer = aws_lb.rds_app_public_alb.arn_suffix
    TargetGroup  = aws_lb_target_group.rds_app_asg_tg.arn_suffix
  }

  alarm_description = "Triggers when RDS App targets return 5 or more 5xx errors in 2 minutes"

  alarm_actions = [aws_sns_topic.rds_app_alb_server_error_alert.arn]

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "rds-app-alb-target-5xx"
    App         = local.app
    Environment = local.env
    Component   = "alarm-alb"
    Scope       = "monitoring-backend"
    Severity    = "high"
  }
}