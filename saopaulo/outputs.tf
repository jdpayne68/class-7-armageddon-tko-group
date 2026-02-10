# outputs.tf - Core Lab 1C Outputs Only

output "chewbacca_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.chewbacca_vpc01.id
}

output "chewbacca_ec2_private_ip" {
  description = "Private IP of EC2 instance"
  value       = aws_instance.chewbacca_ec201.private_ip
}

output "chewbacca_alb_dns_name" {
  description = "ALB DNS name (public entry point)"
  value       = aws_lb.chewbacca_alb01.dns_name
}

output "chewbacca_ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.chewbacca_ec201.id
}

# output "chewbacca_rds_endpoint" {
#   description = "RDS endpoint"
#   value       = aws_db_instance.chewbacca_rds01.endpoint
# }

# output "chewbacca_rds_identifier" {
#   description = "RDS instance identifier"
#   value       = aws_db_instance.chewbacca_rds01.id
# }

# output "chewbacca_secret_id" {
#   description = "Secrets Manager secret ID"
#   value       = aws_secretsmanager_secret.chewbacca_db_secret01.name
# }

output "chewbacca_sns_topic_arn" {
  description = "SNS Topic ARN for alerts"
  value       = aws_sns_topic.chewbacca_sns_topic01.arn
}

# --- TGW Output (Phase 1) ---
output "liberdade_tgw_id" {
  value       = aws_ec2_transit_gateway.liberdade_tgw01.id
  description = "São Paulo Transit Gateway ID (needed by Tokyo for peering)"
}