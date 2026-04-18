
#Target Group Configurations

#RDS App ASG Target Group
resource "aws_lb_target_group" "rds_app_asg_tg" {
  name        = "rds-app-asg-tg"
  target_type = "instance"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.main.id

  load_balancing_algorithm_type     = "round_robin"
  load_balancing_cross_zone_enabled = true

  # Health Check Configuration
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    path                = "/"    # For HTTP and HTTPS health checks, the default is "/". For gRPC health checks, the default is "/AWS.ALB/healthcheck".
    protocol            = "HTTP" # TCP (Layer 4) is not supported for health checks if the protocol of the target group is HTTP or HTTPS (Layer 7). This is a mismatch and won't work.
    port                = "80"
    timeout             = 6
    unhealthy_threshold = 3
  }
  tags = {
    Name        = "rds-app-asg-tg"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Service     = "post-notes"
    Component   = "load-balancing"
    Scope       = "frontend"
  }
}