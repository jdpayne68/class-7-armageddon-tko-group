############################################
# CloudWatch Logs (Log Group)
############################################

# Explanation: When the Falcon is on fire, logs tell you *which* wire sparked—ship them centrally.
resource "aws_cloudwatch_log_group" "armageddon_log_group01" {
  name              = "/aws/ec2/${local.armageddon_prefix}-rds-app"
  retention_in_days = 7

  tags = {
    Name = "${local.armageddon_prefix}-log-group01"
  }
}
