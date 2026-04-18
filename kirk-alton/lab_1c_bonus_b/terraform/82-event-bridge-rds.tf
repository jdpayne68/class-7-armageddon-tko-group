resource "aws_db_event_subscription" "rds_failure_events" {
  name      = "rds-failure-events"
  sns_topic = aws_sns_topic.rds_failure_alert.arn

  source_type = "db-instance"
  source_ids  = [aws_db_instance.lab_mysql.identifier]

  event_categories = [
    "failure"
  ]
  enabled = true
}