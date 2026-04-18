# ----------------------------------------------------------------
# COMPUTE — Local Rendered Files (Debug / Artifact Output)
# ----------------------------------------------------------------

# Make it a habit to render template files with local_file resource. This is extremely helpful for debugging.

# Local File - Rendered EC2 User Data
resource "local_file" "ec2_user_data" {
  filename = "${path.root}/rendered/${var.context.region}/ec2_user_data-${var.name_suffix}.sh"
  content  = local.rds_app_user_data
}

# Local File - Rendered ASG User Data
resource "local_file" "asg_user_data" {
  filename = "${path.root}/rendered/${var.context.region}/asg_user_data-${var.name_suffix}.sh"
  content  = local.rds_app_user_data
}

# Local File - Rendered CloudWatch Agent Configuration File
resource "local_file" "cloudwatch_agent_config" {
  content  = local.cloudwatch_agent_config
  filename = "${path.root}/rendered/${var.context.region}/cloudwatch-agent-config-${var.name_suffix}.json"
}