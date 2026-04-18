# ----------------------------------------------------------------
# COMPUTE — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — TLS (ACM)
# ----------------------------------------------------------------

output "rds_app_cert_arn" {
  description = "ACM certificate ARN (ALB)."
  value       = aws_acm_certificate.rds_app_cert.arn
}

# ----------------------------------------------------------------
# OUTPUTS — Load Balancer
# ----------------------------------------------------------------

output "alb_dns_name" {
  description = "ALB DNS name."
  value       = aws_lb.rds_app_public_alb.dns_name
}

output "alb_zone_id" {
  description = "ALB hosted zone ID."
  value       = aws_lb.rds_app_public_alb.zone_id
}

output "alb_listeners" {
  description = "ALB listener ports."
  value = {
    http  = aws_lb_listener.rds_app_http_80.port
    https = aws_lb_listener.rds_app_https_443.port
  }
}

# ----------------------------------------------------------------
# OUTPUTS — Target Group
# ----------------------------------------------------------------

output "rds_app_asg_tg_arn" {
  description = "ASG target group ARN."
  value       = aws_lb_target_group.rds_app_asg_tg.arn
}

output "rds_app_asg_tg_arn_suffix" {
  description = "Target group ARN suffix."
  value       = aws_lb_target_group.rds_app_asg_tg.arn_suffix
}

output "rds_app_asg_tg_name" {
  description = "Target group name."
  value       = aws_lb_target_group.rds_app_asg_tg.name
}

output "rds_app_asg_tg_id" {
  description = "Target group ID."
  value       = aws_lb_target_group.rds_app_asg_tg.id
}

# ----------------------------------------------------------------
# OUTPUTS — ALB
# ----------------------------------------------------------------

output "rds_app_public_alb_arn" {
  description = "ALB ARN."
  value       = aws_lb.rds_app_public_alb.arn
}

output "rds_app_public_alb_arn_suffix" {
  description = "ALB ARN suffix."
  value       = aws_lb.rds_app_public_alb.arn_suffix
}

output "rds_app_public_alb_dns_name" {
  description = "ALB DNS name."
  value       = aws_lb.rds_app_public_alb.dns_name
}

output "rds_app_public_alb_zone_id" {
  description = "ALB hosted zone ID."
  value       = aws_lb.rds_app_public_alb.zone_id
}

output "rds_app_public_alb_id" {
  description = "ALB ID."
  value       = aws_lb.rds_app_public_alb.id
}

output "rds_app_public_alb_name" {
  description = "ALB name."
  value       = aws_lb.rds_app_public_alb.name
}

# ----------------------------------------------------------------
# OUTPUTS — Auto Scaling Group
# ----------------------------------------------------------------

output "rds_app_asg_name" {
  description = "ASG name."
  value       = aws_autoscaling_group.rds_app_asg.name
}

output "rds_app_asg_arn" {
  description = "ASG ARN."
  value       = aws_autoscaling_group.rds_app_asg.arn
}

output "rds_app_asg_id" {
  description = "ASG ID."
  value       = aws_autoscaling_group.rds_app_asg.id
}

output "rds_app_asg_desired_capacity" {
  description = "ASG desired capacity."
  value       = aws_autoscaling_group.rds_app_asg.desired_capacity
}

output "rds_app_asg_min_size" {
  description = "ASG minimum size."
  value       = aws_autoscaling_group.rds_app_asg.min_size
}

output "rds_app_asg_max_size" {
  description = "ASG maximum size."
  value       = aws_autoscaling_group.rds_app_asg.max_size
}