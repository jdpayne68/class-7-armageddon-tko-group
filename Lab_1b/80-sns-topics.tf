# RDS Failure Alert
resource "aws_sns_topic" "rds_failure_alert" {
  name = "rds-failure-alert"

  tags = {
    Name        = "rds-failure-alert"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "alert-db"
    Scope       = "monitoring-availability"
    Severity    = "high"
  }
}
# Email Subscription - RDS Failure Alert
resource "aws_sns_topic_subscription" "rds_failure_email_alert" {
  topic_arn = aws_sns_topic.rds_failure_alert.arn
  protocol  = "email"
  endpoint  = "jacques.payne@gmail.com" # Replace with your email address
}


# App to RDS Connection Failure Alert
resource "aws_sns_topic" "app_to_rds_connection_failure_alert" {
  name = "app-to-rds-connection-failure-alert"

  tags = {
    Name        = "app-to-rds-connection-failure-alert"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "alert-db"
    Scope       = "monitoring-connectivity"
    Severity    = "medium"
  }
}
# Email Subscription - App to RDS Connection Failure Alert
resource "aws_sns_topic_subscription" "app_to_rds_connection_failure_email_alert" {
  topic_arn = aws_sns_topic.app_to_rds_connection_failure_alert.arn
  protocol  = "email"
  endpoint  = "jacques.payne@gmail.com" # Replace with your email address
}


# Lab MySQL DB Auth Failure Alert
resource "aws_sns_topic" "lab_mysql_auth_failure_alert" {
  name = "lab-mysql-auth-failure-alert"

  tags = {
    Name        = "lab-mysql-auth-failure-alert"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "alert-db"
    Scope       = "monitoring-login"
    Severity    = "medium"
  }
}
# Email Subscription - Lab MySQL DB Auth Failure Alert
resource "aws_sns_topic_subscription" "lab_mysql_auth_failure_email_alert" {
  topic_arn = aws_sns_topic.lab_mysql_auth_failure_alert.arn
  protocol  = "email"
  endpoint  = "jacques.payne@gmail.com" # Replace with your email address
}
