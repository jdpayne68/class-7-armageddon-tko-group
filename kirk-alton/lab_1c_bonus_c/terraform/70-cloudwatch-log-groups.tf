# CWL Group - VPC Traffic
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "vpc-flow-log-${local.name_suffix}"
  retention_in_days = 1
  tags = {
    Name        = "vpc-flow-log"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "logs-vpc"
    Scope       = "logging-conectivity"
    DataClass   = "internal"
  }
}


# CWL Group - RDS App ALB Logs
resource "aws_cloudwatch_log_group" "rds_app_alb_server_error" {
  name              = "rds-app-alb-server-error-${local.name_suffix}"
  retention_in_days = 1

  tags = {
    Name        = "rds-app-alb-server-error"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "logs-alb"
    Scope       = "logging-backend"
    DataClass   = "internal"
  }
}
