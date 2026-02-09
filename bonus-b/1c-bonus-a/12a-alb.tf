############################################
# Application Load Balancer
############################################

# Explanation: The ALB is your public customs checkpoint — it speaks TLS and forwards to private targets.
resource "aws_lb" "armageddon_alb01" {
  name               = "${var.project_name}-alb01"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.armageddon_alb_sg01.id]
  subnets         = aws_subnet.armageddon_public_subnets[*].id


  access_logs {
    bucket  = aws_s3_bucket.armageddon_alb_logs_bucket01[0].bucket
    prefix  = var.alb_access_logs_prefix
    enabled = var.enable_alb_access_logs
  } # TODO: students can enable access logs to S3 as a stretch goal

  tags = {
    Name = "${var.project_name}-alb01"
  }
}
