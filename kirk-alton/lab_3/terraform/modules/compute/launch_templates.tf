# ----------------------------------------------------------------
# COMPUTE — Launch Templates (RDS App ASG)
# ----------------------------------------------------------------

# Launch Template for RDS App Auto Scaling Group
resource "aws_launch_template" "rds_app_asg" {
  provider = aws.regional

  name     = "rds-app-asg-lt"
  image_id = var.ami_id
  #image_id = data.aws_ssm_parameter.al2023.value  # Alternatively, use latest AL2023 AMI via SSM Parameter Store (From Aaron's code. Looks simpler)

  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.rds_app_asg_sg_id]

  user_data = base64encode(local.rds_app_user_data)

  ebs_optimized                        = true
  instance_initiated_shutdown_behavior = "terminate"

  # Force Terraform to wait for role and policies to attach to instance profile before creating launch template and EC2 instances.

  iam_instance_profile {
    name = var.rds_app_instance_profile_name
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "rds-app-asg-instance"
      App         = "${var.context.app}"
      Environment = "${var.context.env}"
      Service     = "post-notes"
      Component   = "compute-ec2"
      Scope       = "frontend"
    }
  }
}