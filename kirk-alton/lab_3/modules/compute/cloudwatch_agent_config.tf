# ----------------------------------------------------------------
# OBSERVABILITY — CloudWatch Agent Configuration
# ----------------------------------------------------------------

# SSM Parameter Store - CloudWatch Agent Configuration
resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  provider = aws.regional

  name  = "/rds-app/cloudwatch-agent/config-${var.name_suffix}"
  type  = "SecureString"
  value = local.cloudwatch_agent_config

  tags = {
    Name         = "rds-app-cloudwatch-agent-config"
    Component    = "logging"
    AppComponent = "log-configuration-parameters"
    DataClass    = "internal"
  }
}