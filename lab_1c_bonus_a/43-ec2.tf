# Instance Profiles

# Instance Profile - RDS App
resource "aws_iam_instance_profile" "rds_app" {
  name = "rds-app-instance-profile"
  role = aws_iam_role.rds_app.name

  tags = {
    Name        = "rds-app-instance-profile"
    Component   = "iam"
    AccessLevel = "read-and-write"
    Service     = "ec2"
    Scope       = "rds-app"
  }
}


# EC2 Instances

# EC2 - RDS App EC2
resource "aws_instance" "rds_app" {
  launch_template {
    id      = aws_launch_template.rds_app_ec2.id
    version = "$Latest"
  }

  subnet_id = local.random_private_app_subnet
  vpc_security_group_ids = [aws_security_group.rds_app_ec2.id]

  associate_public_ip_address = false

  # EC2 depends on VPC Endpoints for access to S3, SSM and CloudWatch Logs (boot script also uses these services)
  depends_on = [
    aws_vpc_endpoint.s3,
    aws_vpc_endpoint.secretsmanager,
    aws_vpc_endpoint.ssm,
    aws_vpc_endpoint.ssm_messages,
    aws_vpc_endpoint.ec2_messages,
    aws_vpc_endpoint.ec2,
    aws_vpc_endpoint.logs
  ]
}