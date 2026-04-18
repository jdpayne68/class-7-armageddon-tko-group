# ----------------------------------------------------------------
# OBSERVABILITY — Cloudwatch Dashboard (RDS App Stack)
# ----------------------------------------------------------------

resource "aws_cloudwatch_dashboard" "rds_app_dashboard" {
  dashboard_name = "rds-app-dashboard"

  dashboard_body = jsonencode({
    start          = "-PT6H"
    periodOverride = "inherit"

    widgets = [

      ## ========== APPLICATION ==========
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 8
        height = 6

        properties = {
          title = "ALB Target Group Request Count"

          metrics = [
            [
              "AWS/ApplicationELB", # Namespace
              "RequestCount",       # Metric Name
              
              # Dimensions
              "TargetGroup", aws_lb_target_group.rds_app_asg_tg.arn_suffix,
              "LoadBalancer", aws_lb.rds_app_public_alb.arn_suffix
            ]
          ]

          region = local.region
          stat   = "Sum"
          period = 60
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 8
        y      = 0
        width  = 8
        height = 6

        properties = {
          title = "ASG CPU Utilization"

          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",

              "AutoScalingGroupName", aws_autoscaling_group.rds_app_asg.name
            ]
          ]

          stat   = "Average"
          region = local.region
          period = 300
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 16
        y      = 0
        width  = 8
        height = 6

        properties = {
          title = "RDS CPU & Freeable Memory"

          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",

              "DBInstanceIdentifier", aws_db_instance.lab_mysql.identifier
            ],
            [
              ".", # Reuse Namespace.
              "FreeableMemory", # New Metric for same DB Instance
              
              ".", "." # Reuse DBInstnceIdentifier
            ]
          ]

          region = local.region
          period = 300
          view   = "timeSeries"
        }
      },

      ## ========== TRAFFIC & SECURITY ==========
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 8
        height = 6

        properties = {
          title = "CloudFront WAF Blocked Requests"

          metrics = [
            [
              "AWS/WAFV2",
              "BlockedRequests",
              

              "WebACL", aws_wafv2_web_acl.rds_app.name,
              "Region", "Global",
              "Rule", "ALL"
            ]
          ]
          region = "us-east-1"
          period = 300
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 8
        y      = 6
        width  = 8
        height = 6

        properties = {
          title = "ALB 5xx Errors (Target vs Infra)"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
             
              "LoadBalancer", aws_lb.rds_app_public_alb.arn_suffix,
              "TargetGroup", aws_lb_target_group.rds_app_asg_tg.arn_suffix,
              {
                stat  = "Sum",
                label = "Target 5xx (App)"
              }
            ],
            [
              "AWS/ApplicationELB",
              "HTTPCode_ELB_5XX_Count",

              "LoadBalancer", aws_lb.rds_app_public_alb.arn_suffix,
              {
                stat  = "Sum",
                label = "ELB 5xx (Infra)"
              }
            ]
          ]

          region  = local.region
          period  = 60
          view    = "timeSeries"
          stacked = false
        }
      },
      {
        type   = "metric"
        x      = 16
        y      = 6
        width  = 8
        height = 6

        properties = {
          title = "MySQL Auth Failures"

          metrics = [
            [
              "Custom/RDS",
              "MySQLAuthFailure",
              {
                stat = "Sum"
              }
            ]
          ]

          region = local.region
          view   = "timeSeries"
          period = 60
        }
      },

      ## ========== ALARMS ==========
      {
        type   = "alarm"
        x      = 0
        y      = 12
        width  = 8
        height = 6

        properties = {
          title = "ALB Target 5xx Alarm"
          alarms = [
            aws_cloudwatch_metric_alarm.rds_app_alb_target_5xx_alarm.arn
          ]
        }
      },


      {
        type   = "alarm"
        x      = 8
        y      = 12
        width  = 8
        height = 6

        properties = {
          title  = "App → MySQL Connection Failures"
          alarms = [aws_cloudwatch_metric_alarm.rds_app_to_lab_mysql_connection_failure.arn]
        }
      },
      {
        type   = "alarm"
        x      = 16
        y      = 12
        width  = 8
        height = 6

        properties = {
          title  = "DB Auth Failures"
          alarms = [aws_cloudwatch_metric_alarm.alarm_lab_mysql_auth_failure.arn]
        }
      }
    ]
  })
}