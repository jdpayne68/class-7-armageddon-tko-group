resource "aws_lb_listener" "armageddon_http_listener01" {
  load_balancer_arn = aws_lb.armageddon_alb01.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener" "armageddon_https_listener01" {
  load_balancer_arn = aws_lb.armageddon_alb01.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.armageddon_acm_validation01.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.armageddon_tg01.arn
  }

  depends_on = [aws_acm_certificate_validation.armageddon_acm_validation01]
}
