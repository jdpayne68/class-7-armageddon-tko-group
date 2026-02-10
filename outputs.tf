# Explanation: Outputs are your mission report—what got built and where to find it.
output "abebe_vpc_id" {
  value = aws_vpc.abebe_vpc01.id
}

output "abebe_public_subnet_ids" {
  value = aws_subnet.abebe_public_subnets[*].id
}

output "abebe_private_subnet_ids" {
  value = aws_subnet.abebe_private_subnets[*].id
}

output "abebe_ec2_instance_id" {
  value = aws_instance.abebe_ec2_01.id
}

output "abebe_rds_endpoint" {
  value = aws_db_instance.abebe_rds01.address
}

output "abebe_sns_topic_arn" {
  value = aws_sns_topic.abebe_sns_topic01.arn
}

output "abebe_log_group_name" {
  value = aws_cloudwatch_log_group.abebe_log_group01.name
}

#Bonus-A outputs (append to outputs.tf)

# Explanation: These outputs prove abebe built private hyperspace lanes (endpoints) instead of public chaos.
output "abebe_vpce_ssm_id" {
  value = aws_vpc_endpoint.abebe_vpce_ssm01.id
}

output "abebe_vpce_logs_id" {
  value = aws_vpc_endpoint.abebe_vpce_logs01.id
}

output "abebe_vpce_secrets_id" {
  value = aws_vpc_endpoint.abebe_vpce_secrets01.id
}

output "abebe_vpce_s3_id" {
  value = aws_vpc_endpoint.abebe_vpce_s3_gw01.id
}

output "abebe_private_ec2_instance_id_bonus" {
  value = aws_instance.abebe_ec201_private_bonus.id
}