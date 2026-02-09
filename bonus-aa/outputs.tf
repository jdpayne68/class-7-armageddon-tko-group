# Explanation: Outputs are your mission report—what got built and where to find it.
output "armageddon_vpc_id" {
  value = aws_vpc.armageddon_vpc01.id
}

output "armageddon_public_subnet_ids" {
  value = aws_subnet.armageddon_public_subnets[*].id
}

output "armageddon_private_subnet_ids" {
  value = aws_subnet.armageddon_private_subnets[*].id
}

output "armageddon_ec2_instance_id" {
  value = aws_instance.armageddon_ec201.id
}

output "armageddon_rds_endpoint" {
  value = aws_db_instance.lab-mysql.address
}

output "armageddon_sns_topic_arn" {
  value = aws_sns_topic.armageddon_sns_topic01.arn
}

output "armageddon_log_group_name" {
  value = aws_cloudwatch_log_group.armageddon_log_group01.name
}

#Bonus-A outputs (append to outputs.tf)

# Explanation: These outputs prove armageddon built private hyperspace lanes (endpoints) instead of public chaos.
output "armageddon_vpce_ssm_id" {
  value = aws_vpc_endpoint.armageddon_vpce_ssm01.id
}

output "armageddon_vpce_logs_id" {
  value = aws_vpc_endpoint.armageddon_vpce_logs01.id
}

output "armageddon_vpce_secrets_id" {
  value = aws_vpc_endpoint.armageddon_vpce_secrets01.id
}

output "armageddon_vpce_s3_id" {
  value = aws_vpc_endpoint.armageddon_vpce_s3_gw01.id
}

output "armageddon_private_ec2_instance_id_bonus" {
  value = aws_instance.armageddon_ec201_private_bonus.id
}

