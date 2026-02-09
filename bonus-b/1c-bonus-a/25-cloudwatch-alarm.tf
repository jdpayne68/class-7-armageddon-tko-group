############################################
# CloudWatch Alarm: ALB 5xx -> SNS
############################################

# Explanation: When the ALB starts throwing 5xx, that’s the Falcon coughing — page the on-call Wookiee.
resource "aws_cloudwatch_metric_alarm" "armageddon_alb_5xx_alarm01" {
  alarm_name          = "${var.project_name}-alb-5xx-alarm01"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alb_5xx_evaluation_periods
  threshold           = var.alb_5xx_threshold
  period              = var.alb_5xx_period_seconds
  statistic           = "Sum"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"

  dimensions = {
    LoadBalancer = aws_lb.armageddon_alb01.arn_suffix
  }

  alarm_actions = [aws_sns_topic.armageddon_sns_topic01.arn]

  tags = {
    Name = "${var.project_name}-alb-5xx-alarm01"
  }
}
