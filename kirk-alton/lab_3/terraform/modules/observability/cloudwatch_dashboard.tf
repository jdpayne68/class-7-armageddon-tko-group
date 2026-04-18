# ----------------------------------------------------------------
# OBSERVABILITY — CloudWatch Dashboard (RDS App Stack)
# ----------------------------------------------------------------

resource "aws_cloudwatch_dashboard" "rds_app_dashboard" {
  provider = aws.regional

  dashboard_name = "rds-app-dashboard"

  dashboard_body = jsonencode({
    start          = "-PT6H"
    periodOverride = "inherit"

    widgets = concat(

      [
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
                "AWS/ApplicationELB",
                "RequestCount",
                "TargetGroup", var.rds_app_asg_tg_arn_suffix,
                "LoadBalancer", var.rds_app_public_alb_arn_suffix
              ]
            ]

            region = var.context.region
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
                "AutoScalingGroupName", var.rds_app_asg_name
              ]
            ]

            stat   = "Average"
            region = var.context.region
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
                "DBInstanceIdentifier", var.db_identifier
              ],
              [
                ".",
                "FreeableMemory",
                ".", "."
              ]
            ]

            region = var.context.region
            period = 300
            view   = "timeSeries"
          }
        },

        ## ========== ALB ERRORS ==========
        {
          type   = "metric"
          x      = 8
          y      = 6
          width  = 8
          height = 6

          properties = {
            title = "ALB 5xx Errors"

            metrics = [
              [
                "AWS/ApplicationELB",
                "HTTPCode_Target_5XX_Count",
                "LoadBalancer", var.rds_app_public_alb_arn_suffix,
                "TargetGroup", var.rds_app_asg_tg_arn_suffix
              ]
            ]

            region = var.context.region
            period = 60
            view   = "timeSeries"
          }
        }
      ],

      local.waf_widget
    )
  })
}
















# # ----------------------------------------------------------------
# # OBSERVABILITY — CloudWatch Dashboard (RDS App Stack)
# # ----------------------------------------------------------------

# resource "aws_cloudwatch_dashboard" "rds_app_dashboard" {
#   dashboard_name = "rds-app-dashboard"

#   dashboard_body = jsonencode({
#     start          = "-PT6H"
#     periodOverride = "inherit"

#     widgets = [

#       ## ========== APPLICATION ==========
#       {
#         type   = "metric"
#         x      = 0
#         y      = 0
#         width  = 8
#         height = 6

#         properties = {
#           title = "ALB Target Group Request Count"

#           metrics = [
#             [
#               "AWS/ApplicationELB", # Namespace
#               "RequestCount",       # Metric Name

#               # Dimensions
#               "TargetGroup", var.rds_app_asg_tg_arn_suffix,
#               "LoadBalancer", var.rds_app_public_alb_arn_suffix
#             ]
#           ]

#           region = var.context.region
#           stat   = "Sum"
#           period = 60
#           view   = "timeSeries"
#         }
#       },
#       {
#         type   = "metric"
#         x      = 8
#         y      = 0
#         width  = 8
#         height = 6

#         properties = {
#           title = "ASG CPU Utilization"

#           metrics = [
#             [
#               "AWS/EC2",
#               "CPUUtilization",

#               "AutoScalingGroupName", var.rds_app_asg_name
#             ]
#           ]

#           stat   = "Average"
#           region = var.context.region
#           period = 300
#           view   = "timeSeries"
#         }
#       },
#       {
#         type   = "metric"
#         x      = 16
#         y      = 0
#         width  = 8
#         height = 6

#         properties = {
#           title = "RDS CPU & Freeable Memory"

#           metrics = [
#             [
#               "AWS/RDS",
#               "CPUUtilization",

#               "DBInstanceIdentifier", var.db_identifier
#             ],
#             [
#               ".",              # Reuse Namespace.
#               "FreeableMemory", # New Metric for same DB Instance

#               ".", "." # Reuse DBInstnceIdentifier
#             ]
#           ]

#           region = var.context.region
#           period = 300
#           view   = "timeSeries"
#         }
#       },

#       ## ========== TRAFFIC & SECURITY ==========
#       {
#         type   = "metric"
#         x      = 0
#         y      = 6
#         width  = 8
#         height = 6

#         properties = {
#           title = "CloudFront WAF Blocked Requests"

#           metrics = [
#             [
#               "AWS/WAFV2",
#               "BlockedRequests",


#               #"WebACL", var.rds_app_waf_name, # TODO # FIXME
#               "WebACL", tostring(try(var.rds_app_waf_name, "")),
#               "Region", "Global",
#               "Rule", "ALL"
#             ]
#           ]
#           region = "us-east-1"
#           period = 300
#           view   = "timeSeries"
#         }
#       },
#       {
#         type   = "metric"
#         x      = 8
#         y      = 6
#         width  = 8
#         height = 6

#         properties = {
#           title = "ALB 5xx Errors (Target vs Infra)"

#           metrics = [
#             [
#               "AWS/ApplicationELB",
#               "HTTPCode_Target_5XX_Count",

#               "LoadBalancer", var.rds_app_public_alb_arn_suffix,
#               "TargetGroup", var.rds_app_asg_tg_arn_suffix,
#               {
#                 stat  = "Sum",
#                 label = "Target 5xx (App)"
#               }
#             ],
#             [
#               "AWS/ApplicationELB",
#               "HTTPCode_ELB_5XX_Count",

#               "LoadBalancer", var.rds_app_public_alb_arn_suffix,
#               {
#                 stat  = "Sum",
#                 label = "ELB 5xx (Infra)"
#               }
#             ]
#           ]

#           region  = var.context.region
#           period  = 60
#           view    = "timeSeries"
#           stacked = false
#         }
#       },
#       {
#         type   = "metric"
#         x      = 16
#         y      = 6
#         width  = 8
#         height = 6

#         properties = {
#           title = "MySQL Auth Failures"

#           metrics = [
#             [
#               "Custom/RDS",
#               "MySQLAuthFailure",
#               {
#                 stat = "Sum"
#               }
#             ]
#           ]

#           region = var.context.region
#           view   = "timeSeries"
#           period = 60
#         }
#       },

#       ## ========== ALARMS ==========
#       {
#         type   = "alarm"
#         x      = 0
#         y      = 12
#         width  = 8
#         height = 6

#         properties = {
#           title = "ALB Target 5xx Alarm"
#           alarms = [
#             aws_cloudwatch_metric_alarm.rds_app_alb_target_5xx_alarm.arn
#           ]
#         }
#       },


#       {
#         type   = "alarm"
#         x      = 8
#         y      = 12
#         width  = 8
#         height = 6

#         properties = {
#           title  = "App → MySQL Connection Failures"
#           alarms = [aws_cloudwatch_metric_alarm.rds_app_to_lab_mysql_connection_failure.arn]
#         }
#       },
#       {
#         type   = "alarm"
#         x      = 16
#         y      = 12
#         width  = 8
#         height = 6

#         properties = {
#           title  = "DB Auth Failures"
#           alarms = [aws_cloudwatch_metric_alarm.alarm_lab_mysql_auth_failure.arn]
#         }
#       }
#     ]
#   })
# }