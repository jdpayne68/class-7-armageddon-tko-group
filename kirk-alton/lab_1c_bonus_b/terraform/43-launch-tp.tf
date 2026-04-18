# Launch Template for RDS App Auto Scaling Group
resource "aws_launch_template" "rds_app_asg" {
  name     = "rds-app-asg-lt"
  image_id = "ami-0365298ecd8182a83" # Replace with the AMI for your Golden Image (AL2023).
  #image_id = data.aws_ssm_parameter.al2023.value  # Alternatively, use latest AL2023 AMI via SSM Parameter Store (From Aaron's code. Looks simpler)
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.rds_app_asg.id]

  user_data = base64encode(local.rds_app_user_data)

  ebs_optimized                        = true
  instance_initiated_shutdown_behavior = "terminate"

  # Force Terraform to wait for role and policies to attach to instance profile before creating launch template and EC2 instances.
  depends_on = [
    aws_iam_instance_profile.rds_app,
    aws_iam_role_policy_attachment.attach_read_db_secret,
    aws_iam_role_policy_attachment.attach_read_db_host_parameter,
    aws_iam_role_policy_attachment.attach_read_db_port_parameter,
    aws_iam_role_policy_attachment.attach_read_db_name_parameter,
    aws_iam_role_policy_attachment.attach_read_db_username_parameter
  ]


  iam_instance_profile {
    name = aws_iam_instance_profile.rds_app.name
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "rds-app-asg-instance"
      App         = "${local.application}"
      Environment = "${local.environment}"
      Service     = "post-notes"
      Component   = "compute-ec2"
      Scope       = "frontend"
    }
  }
}