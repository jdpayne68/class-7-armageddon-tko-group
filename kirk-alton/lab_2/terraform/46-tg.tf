# ----------------------------------------------------------------
# LOAD BALANCING — Target Group (RDS App ASG)
# ----------------------------------------------------------------

# Target Group Configurations

# RDS App ASG Target Group
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
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    timeout             = 6
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "rds-app-asg-tg"
    App         = "${local.app}"
    Environment = "${local.env}"
    Service     = "post-notes"
    Component   = "load-balancing"
    Scope       = "frontend"
  }
}