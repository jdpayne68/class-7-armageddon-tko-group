
# Auto Scaling Group for RDS App ASG
resource "aws_autoscaling_group" "rds_app_asg" {
  name                = "rds-app-asg"
  vpc_zone_identifier = local.private_app_subnets

  desired_capacity  = 2
  max_size          = 6
  min_size          = 2
  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.rds_app_asg_tg.arn] # Target group to attach the ASG to. A list of ARNS is expected for an ASG, so use brackets and add an "s" make "target_group_arn" plural.
  force_delete      = true

  depends_on = [
    aws_vpc_endpoint.s3,
    aws_vpc_endpoint.secretsmanager,
    aws_vpc_endpoint.ssm,
    aws_vpc_endpoint.ssm_messages,
    aws_vpc_endpoint.ec2_messages,
    aws_vpc_endpoint.ec2,
    aws_vpc_endpoint.logs
  ]

  launch_template {
    id      = aws_launch_template.rds_app_asg.id
    version = "$Latest"
  }
  tag {
    key                 = "ManagedBy" # Keep this tag block and expand to add fine grained metadata to the instances (launch template handles main tags like name, owner, etc.)
    value               = "terraform"
    propagate_at_launch = true
  }

}

# ASG Policy
resource "aws_autoscaling_policy" "rds_app_asg" {
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