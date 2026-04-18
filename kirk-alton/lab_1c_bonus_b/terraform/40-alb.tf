# Public Application Load Balancer
resource "aws_lb" "rds_app_public_alb" {
  name               = "rds-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.public_subnets


  enable_deletion_protection = false

  # Access Logs for ALB
  access_logs {
    bucket  = aws_s3_bucket.terraform_bucket.id
    prefix  = "rds-app/logs/alb-logs"
    enabled = true
  }

  tags = {
    Name        = "rds-app-alb"
    Component   = "load-balancing"
    Environment = "${local.environment}"
    Service     = "post-notes"
  }
}