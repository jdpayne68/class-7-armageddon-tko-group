# VPC Flow Log
resource "aws_flow_log" "vpc" {
  iam_role_arn = aws_iam_role.vpc_flow_log_role.arn

  log_format = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
  # Default fields for AWS Flow Logs.
  # Version, Account ID, ENI, Source Adress, Destination Address, Source Port, Destination Port, Protcol, Packets, Bytes, Start, End, Action, Log Status
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn # CloudWatch as a destination doesn't require log_destination_type (other destinations require it).

  traffic_type = "ALL"
  vpc_id       = aws_vpc.main.id
  tags = {
    Name        = "main-vpc-flow-log"
    App         = local.application
    Environment = local.environment
    Component   = "logging-vpc"
    Scope       = "network"
    }
}