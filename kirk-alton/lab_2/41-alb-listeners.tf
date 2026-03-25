# ----------------------------------------------------------------
# LOAD BALANCING — ALB Listeners
# ----------------------------------------------------------------

# ALB Listeners for RDS App Public ALB

# HTTP Listener on Port 80 - Redirects to HTTPS on Port 443
resource "aws_lb_listener" "rds_app_http_80" {
  load_balancer_arn = aws_lb.rds_app_public_alb.arn
  protocol          = "HTTP"
  port              = "80"

  tags = {
    Name        = "rds-app-http-80-listener"
    Component   = "load-balancing"
    Environment = "${local.env}"
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
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" # Newer SSL Policy. ELBSecurityPolicy-2016-08 is outdated; legacy support"
  certificate_arn   = aws_acm_certificate_validation.rds_app_cert.certificate_arn

  tags = {
    Name        = "rds-app-https-443-listener"
    Component   = "load-balancing"
    Environment = "${local.env}"
    Service     = "post-notes"
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rds_app_asg_tg.arn
  }
}

# ----------------------------------------------------------------
# LOAD BALANCING — Origin Protection (Cloudfront Header Token)
# ----------------------------------------------------------------

# Edge Auth Token (Header Value)
resource "random_password" "edge_auth_value" {
  length  = 32
  special = false
}

# Allow Rule - Valid Edge Auth Header
resource "aws_lb_listener_rule" "accept_edge_auth" {
  listener_arn = aws_lb_listener.rds_app_https_443.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rds_app_asg_tg.arn
  }

  condition {
    http_header {
      http_header_name = local.edge_auth_header_name
      values           = [random_password.edge_auth_value.result]
    }
  }
}

# Default Deny - Block Direct Origin Access
resource "aws_lb_listener_rule" "default_deny" {
  listener_arn = aws_lb_listener.rds_app_https_443.arn
  priority     = 99

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }

  condition {
    path_pattern { values = ["/*"] }
  }
}