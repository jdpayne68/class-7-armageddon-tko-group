# ----------------------------------------------------------------
# OBSERVABILITY — Alerting SNS Topics (Database Availability)
# ----------------------------------------------------------------

resource "aws_sns_topic" "rds_failure_alert" {
  provider = aws.regional

  name = "rds-failure-alert"

  tags = {
    Name        = "rds-failure-alert"
    App         = "${var.context.app}"
    Environment = "${var.context.env}"
    Component   = "alert-db"
    Scope       = "monitoring-availability"
    Severity    = "high"
  }
}

resource "aws_sns_topic_subscription" "rds_failure_email_alert" {
  provider = aws.regional

  topic_arn = aws_sns_topic.rds_failure_alert.arn
  protocol  = "email"
  endpoint  = "email@icloud.com"
}

# ----------------------------------------------------------------
# OBSERVABILITY — Alerting SNS Topics (Application → Database Connectivity)
# ----------------------------------------------------------------

resource "aws_sns_topic" "app_to_rds_connection_failure_alert" {
  provider = aws.regional

  name = "app-to-rds-connection-failure-alert"

  tags = {
    Name        = "app-to-rds-connection-failure-alert"
    App         = "${var.context.app}"
    Environment = "${var.context.env}"
    Component   = "alert-db"
    Scope       = "monitoring-connectivity"
    Severity    = "medium"
  }
}

resource "aws_sns_topic_subscription" "app_to_rds_connection_failure_email_alert" {
  provider = aws.regional

  topic_arn = aws_sns_topic.app_to_rds_connection_failure_alert.arn
  protocol  = "email"
  endpoint  = "email@icloud.com"
}

# ----------------------------------------------------------------
# OBSERVABILITY — Alerting SNS Topics (Database Authentication)
# ----------------------------------------------------------------

resource "aws_sns_topic" "lab_mysql_auth_failure_alert" {
  provider = aws.regional

  name = "lab-mysql-auth-failure-alert"

  tags = {
    Name        = "lab-mysql-auth-failure-alert"
    App         = "${var.context.app}"
    Environment = "${var.context.env}"
    Component   = "alert-db"
    Scope       = "monitoring-login"
    Severity    = "medium"
  }
}

resource "aws_sns_topic_subscription" "lab_mysql_auth_failure_email_alert" {
  provider = aws.regional

  topic_arn = aws_sns_topic.lab_mysql_auth_failure_alert.arn
  protocol  = "email"
  endpoint  = "email@icloud.com"
}

# ----------------------------------------------------------------
# OBSERVABILITY — Alerting SNS Topics (Application Load Balancer Errors)
# ----------------------------------------------------------------

resource "aws_sns_topic" "rds_app_alb_server_error_alert" {
  provider = aws.regional

  name = "rds-app-alb-server-error-alert"

  tags = {
    Name        = "rds-app-alb-server-error-alert"
    App         = "${var.context.app}"
    Environment = "${var.context.env}"
    Component   = "alert-alb"
    Scope       = "monitoring-backend"
    Severity    = "high"
  }
}

resource "aws_sns_topic_subscription" "app_alb_server_error_email_alert" {
  provider = aws.regional

  topic_arn = aws_sns_topic.rds_app_alb_server_error_alert.arn
  protocol  = "email"
  endpoint  = "email@icloud.com"
}