# ----------------------------------------------------------------
# LOAD BALANCING — Application Load Balancer (Public)
# ----------------------------------------------------------------

# Public Application Load Balancer
resource "aws_lb" "rds_app_public_alb" {
  provider = aws.regional

  name               = "rds-app-alb-${var.name_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_origin_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  # Dynamic Access Logs for ALB
  dynamic "access_logs" {
    for_each = var.alb_log_s3 ? [true] : []

    content {
      bucket  = var.alb_logs_bucket_id
      prefix  = var.alb_access_logs_prefix
      enabled = true
    }
  }

  tags = {
    Name        = "rds-app-alb"
    Component   = "load-balancing"
    Environment = "${var.context.env}"
    Service     = "post-notes"
  }
}