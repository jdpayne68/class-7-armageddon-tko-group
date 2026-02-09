resource "aws_security_group" "armageddon_vpce_sg01" {
  name        = "${local.armageddon_prefix}-vpce-sg01"
  description = "SG for VPC Interface Endpoints"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.armageddon_prefix}-vpce-sg01"
  }
}

resource "aws_security_group" "armageddon_ec2_sg01" {
  name        = "${local.name_prefix}-ec2-sg01"
  description = "EC2 app security group"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.name_prefix}-ec2-sg01"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_inbound_http_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.ec2_public_app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_trusted_inbound_ssh_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.ec2_public_app.id
  cidr_ipv4         = local.trusted_ip
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.ec2_public_app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "armageddon_rds_sg01" {
  name        = "${local.name_prefix}-rds-sg01"
  description = "RDS security group"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  tags = {
    Name = "${local.name_prefix}-rds-sg01"
  }
}

resource "aws_db_subnet_group" "armageddon_rds_subnet_group01" {
  name       = "${local.name_prefix}-rds-subnet-group01"
  subnet_ids = aws_subnet.armageddon_private_subnets[*].id

  tags = {
    Name = "${local.name_prefix}-rds-subnet-group01"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_https_from_public_alb_sg" {
  security_group_id            = aws_security_group.rds_app_asg.id
  ip_protocol                  = "tcp"
  to_port                      = 443
  from_port                    = 443
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow all inbound/outbound traffic for HTTP and HTTPS"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "public-application-lb-sg"
  }
}

resource "aws_security_group" "armageddon_alb_sg01" {
  name        = "${var.project_name}-alb-sg01"
  description = "ALB security group"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  # TODO: students add inbound 80/443 from 0.0.0.0/0
  # TODO: students set outbound to target group port (usually 80) to private targets

  tags = {
    Name = "${var.project_name}-alb-sg01"
  }
}
