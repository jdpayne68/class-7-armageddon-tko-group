resource "aws_cloudwatch_dashboard" "armageddon_dashboard01" {
  dashboard_name = "${var.project_name}-dashboard01"

  # TODO: students can expand widgets; this is a minimal workable skeleton
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.armageddon_alb01.arn_suffix],
            [".", "HTTPCode_ELB_5XX_Count", ".", aws_lb.armageddon_alb01.arn_suffix]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "armageddon ALB: Requests + 5XX"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.armageddon_alb01.arn_suffix]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "armageddon ALB: Target Response Time"
        }
      }
    ]
  })
}
