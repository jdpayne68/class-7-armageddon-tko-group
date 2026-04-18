# Make it a habit to render template files with local_file resource. This is extremely helpful for debugging.

# Local File - Rendered EC2 User Data
resource "local_file" "ec2_user_data" {
  filename = "${path.module}/rendered/ec2_user_data-${local.name_suffix}.sh"
  content  = local.rds_app_user_data
}

# Local File - Rendered ASG User Data
resource "local_file" "asg_user_data" {
  filename = "${path.module}/rendered/asg_user_data-${local.name_suffix}.sh"
  content  = local.rds_app_user_data
}

# Local File - Rendered CloudWatch Agent Configuration File
resource "local_file" "cloudwatch_agent_config" {
  content  = local.cloudwatch_agent_config
  filename = "${path.module}/rendered/cloudwatch-agent-config-${local.name_suffix}.json"
}