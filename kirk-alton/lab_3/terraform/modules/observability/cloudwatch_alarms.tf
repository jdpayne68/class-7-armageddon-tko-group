# ----------------------------------------------------------------
# DETECTION — Metric Filter (VPC Flow Logs: App → DB Reject)
# ----------------------------------------------------------------

# Metric
resource "aws_cloudwatch_log_metric_filter" "rds_app_to_lab_mysql_connection_failure" {
  provider = aws.regional

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

# ----------------------------------------------------------------
# DETECTION — Alarm (App → DB Connectivity Failure)
# ----------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_app_to_lab_mysql_connection_failure" {
  provider = aws.regional

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

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "app-to-lab-mysql-connection-failure"
    App         = var.context.app
    Environment = var.context.env
    Component   = "alarm-db"
    Scope       = "monitoring-connectivity"
    Severity    = "medium"
  }
}

# ----------------------------------------------------------------
# DETECTION — Metric Filter (RDS Error Log: Auth Failure)
# ----------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "lab_mysql_auth_failure" {
  count    = var.enable_db_observability ? 1 : 0
  provider = aws.regional

  name           = "lab-mysql-auth-failure"
  log_group_name = "/aws/rds/instance/${var.db_identifier}/error"

  pattern = "Access denied for user"

  metric_transformation {
    name      = "MySQLAuthFailure"
    namespace = "Custom/RDS"
    value     = "1"
  }
}

# ----------------------------------------------------------------
# DETECTION — Alarm (Database Auth Failure)
# ----------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "alarm_lab_mysql_auth_failure" {
  provider = aws.regional

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

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "alarm-lab-mysql-auth-failures"
    App         = var.context.app
    Environment = var.context.env
    Component   = "alarm-db"
    Scope       = "monitoring-login"
    Severity    = "medium"
  }
}

# ----------------------------------------------------------------
# DETECTION — Alarm (ALB Target 5xx Errors)
# ----------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_app_alb_target_5xx_alarm" {
  provider = aws.regional

  alarm_name          = "rds-app-alb-target-5xx"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 2
  period             = 60
  threshold          = 5
  statistic          = "Sum"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"

  dimensions = {
    LoadBalancer = var.rds_app_public_alb_arn_suffix
    TargetGroup  = var.rds_app_asg_tg_arn_suffix
  }

  alarm_description = "Triggers when RDS App targets return 5 or more 5xx errors in 2 minutes"

  alarm_actions = [aws_sns_topic.rds_app_alb_server_error_alert.arn]

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "rds-app-alb-target-5xx"
    App         = var.context.app
    Environment = var.context.env
    Component   = "alarm-alb"
    Scope       = "monitoring-backend"
    Severity    = "high"
  }
}