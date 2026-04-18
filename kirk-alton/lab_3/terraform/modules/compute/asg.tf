# ----------------------------------------------------------------
# COMPUTE — Auto Scaling Group (RDS App)
# ----------------------------------------------------------------

# Auto Scaling Group for RDS App ASG
resource "aws_autoscaling_group" "rds_app_asg" {
  provider            = aws.regional
  name                = "rds-app-asg"
  vpc_zone_identifier = var.private_app_subnet_ids

  desired_capacity  = 2
  max_size          = 6
  min_size          = 2
  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.rds_app_asg_tg.arn]
  force_delete      = true

  depends_on = [
    var.ec2_vpc_endpoints_ready
  ]

  launch_template {
    id      = aws_launch_template.rds_app_asg.id
    version = "$Latest"
  }

  tag {
    key                 = "ManagedBy"
    value               = "terraform"
    propagate_at_launch = true
  }
}

# ----------------------------------------------------------------
# COMPUTE — Auto Scaling Policies (Target Tracking)
# ----------------------------------------------------------------

# ASG Policy
resource "aws_autoscaling_policy" "rds_app_asg" {
  provider = aws.regional

  name                      = "rds-app-asg-policy"
  autoscaling_group_name    = aws_autoscaling_group.rds_app_asg.id
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}