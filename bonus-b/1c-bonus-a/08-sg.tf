############################################
# Security Groups (EC2 + RDS)
############################################

resource "aws_security_group" "lab-ec2-app" {
  name        = "lab-ec2-app-sg"
  description = "EC2 app security group"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  # TODO: student adds inbound rules (HTTP 80, SSH 22 from their IP)
  # TODO: student ensures outbound allows DB port to RDS SG (or allow all outbound)

  tags = {
    Name = "lab-ec2-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_inbound_http_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.lab-ec2-app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# SG Rule: Allow all SSH Inbound for EC2 Public App SG
resource "aws_vpc_security_group_ingress_rule" "allow_trusted_inbound_ssh_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.lab-ec2-app.id
  cidr_ipv4         = var.local_trusted_ip
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# SG Rule: Allow all Outbound IPv4 for EC2 Public App SG
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.lab-ec2-app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Explanation: RDS SG is the Rebel vault—only the app server gets a keycard.
resource "aws_security_group" "armageddon_rds_sg01" {
  name        = "${local.armageddon_prefix}-rds-sg01"
  description = "RDS security group"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  # TODO: student adds inbound MySQL 3306 from aws_security_group.armageddon_ec2_sg01.id

  tags = {
    Name = "${local.armageddon_prefix}-rds-sg01"
  }
}

# SG Rule: Allow Aurora/MySQL Inbound only from EC2 Public App SG
resource "aws_vpc_security_group_ingress_rule" "allow_inbound_http_from_ec2_public_app" {
  security_group_id            = aws_security_group.armageddon_rds_sg01.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.lab-ec2-app.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4_private_db" {
  security_group_id = aws_security_group.armageddon_rds_sg01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

############################################
# Security Group for VPC Interface Endpoints
############################################

# Explanation: Even endpoints need guards—armageddon posts a Wookiee at every airlock.
resource "aws_security_group" "armageddon_vpce_sg01" {
  name        = "${local.armageddon_prefix}-vpce-sg01"
  description = "SG for VPC Interface Endpoints"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  # TODO: Students must allow inbound 443 FROM the EC2 SG (or VPC CIDR) to endpoints.
  # NOTE: Interface endpoints ENIs receive traffic on 443.

  tags = {
    Name = "${local.armageddon_prefix}-vpce-sg01"
  }
}

resource "aws_security_group" "armageddon_ec2_sg01" {
  name        = "${local.name_prefix}-ec2-sg01"
  description = "EC2 app security group"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  # TODO: student adds inbound rules (HTTP 80, SSH 22 from their IP)
  # TODO: student ensures outbound allows DB port to RDS SG (or allow all outbound)

  tags = {
    Name = "${local.name_prefix}-ec2-sg01"
  }
}
