# ----------------------------------------------------------------
# OBSERVABILITY — VPC Flow Log (Network Telemetry)
# ----------------------------------------------------------------

# VPC Flow Log
resource "aws_flow_log" "vpc" {
  iam_role_arn = aws_iam_role.vpc_flow_log_role.arn

  log_format = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
  # Default fields for AWS Flow Logs.
  # Version, Account ID, ENI, Source Address, Destination Address, Source Port, Destination Port, Protocol, Packets, Bytes, Start, End, Action, Log Status

  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  # CloudWatch as a destination doesn't require log_destination_type

  traffic_type = "ALL"
  vpc_id       = aws_vpc.main.id
}
