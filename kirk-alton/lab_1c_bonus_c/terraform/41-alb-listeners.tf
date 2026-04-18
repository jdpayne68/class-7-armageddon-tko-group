# ALB Listeners for RDS App Public ALB

# HTTP Listener on Port 80 - Redirects to HTTPS on Port 443
resource "aws_lb_listener" "rds_app_http_80" {
  load_balancer_arn = aws_lb.rds_app_public_alb.arn
  protocol          = "HTTP"
  port              = "80"

  tags = {
    Name        = "rds-app-http-80-listener"
    Component   = "load-balancing"
    Environment = "${local.environment}"
    Service     = "post-notes"
  }
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener on Port 443 - Forwards to RDS App ASG Target Group
resource "aws_lb_listener" "rds_app_https_443" {
  load_balancer_arn = aws_lb.rds_app_public_alb.arn
  protocol          = "HTTPS"
  port              = 443
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.rds_app_cert.certificate_arn
  # Use the validated certificate ARN from aws_acm_certificate_validation instead of the unvalidated certificate resource.
  # This creates an implicit dependency and guarantees the HTTPS listener is created only after the cert has been fully validated.
  # This is very consistent and more declarative than using depends_on.


  tags = {
    Name        = "rds-app-https-443-listener"
    Component   = "load-balancing"
    Environment = "${local.environment}"
    Service     = "post-notes"
  }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rds_app_asg_tg.arn
  }
}