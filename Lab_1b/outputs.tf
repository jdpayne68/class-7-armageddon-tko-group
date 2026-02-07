output "application_name" {
  description = "Application name"
  value       = var.application_name
}

output "environment" {
  description = "Environment"
  value       = local.environment
}

output "region_choice" {
  description = "Region choice (number)"
  value       = var.region_choice
}

output "region" {
  description = "Region (name)"
  value       = local.region
}

output "availability_zones" {
  description = "Availability Zones"
  value       = data.aws_availability_zones.available.names
}

output "trusted_ip" {
  description = "Trusted IP address for SSH access"
  value       = local.trusted_ip
}
output "vpc_info" {
  description = "VPC ID, Name and CIDR block"
  value = {
    id   = aws_vpc.main.id
    name = aws_vpc.main.tags["Name"]
    cidr = aws_vpc.main.cidr_block
  }
}

output "public_app_info" {
  description = "EC2 Names and Browser Addresses"
  value = {
    name       = aws_instance.public_app.tags["Name"]
    az         = aws_instance.public_app.availability_zone
    subnet_id  = aws_instance.public_app.subnet_id
    ip_address = aws_instance.public_app.public_ip
    url        = "http://${aws_instance.public_app.public_dns}"
  }
}

output "rds_info" {
  description = "RDS Name and Endpoint"
  value = {
    name     = aws_db_instance.lab_mysql.tags["Name"]
    endpoint = aws_db_instance.lab_mysql.endpoint
    address  = aws_db_instance.lab_mysql.address
    port     = aws_db_instance.lab_mysql.port
  }
}

output "rds_subnets" {
  value = aws_db_subnet_group.armageddon_1a_db.subnet_ids
}