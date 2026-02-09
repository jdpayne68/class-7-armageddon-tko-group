############################################
# Custom Metric + Alarm (Skeleton)
############################################

# Explanation: Metrics are armageddon’s growls—when they spike, something is wrong.
# NOTE: Students must emit the metric from app/agent; this just declares the alarm.
resource "aws_cloudwatch_metric_alarm" "armageddon_db_alarm01" {
  alarm_name          = "${local.armageddon_prefix}-db-connection-failure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "DBConnectionErrors"
  namespace           = "Lab/RDSApp"
  period              = 300
  statistic           = "Sum"
  threshold           = 3

  alarm_actions = [aws_sns_topic.armageddon_sns_topic01.arn]

  tags = {
    Name = "${local.name_prefix}-alarm-db-fail"
  }
}
