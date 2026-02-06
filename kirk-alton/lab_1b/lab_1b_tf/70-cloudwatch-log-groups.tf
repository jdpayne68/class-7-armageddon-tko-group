# CWL Group - VPC Traffic
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name = "vpc-flow-log-${local.name_suffix}"

  tags = {
    Name        = "vpc-flow-log"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "logs-vpc"
    Scope       = "logging-conectivity"
    DataClass   = "confidential"
  }
}