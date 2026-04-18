# ----------------------------------------------------------------
# ALERTING — RDS Event Subscriptions (Database Failure Events)
# ----------------------------------------------------------------

resource "aws_db_event_subscription" "rds_failure_events" {
  provider = aws.regional

  name      = "rds-failure-events"
  sns_topic = var.rds_failure_alert_topic_arn

  source_type = "db-instance"
  source_ids  = [aws_db_instance.lab_mysql.identifier]

  event_categories = [
    "failure"
  ]

  enabled = true
}