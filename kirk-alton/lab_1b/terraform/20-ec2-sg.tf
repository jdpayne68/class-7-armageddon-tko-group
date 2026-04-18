# EC2 Public App Security Group
resource "aws_security_group" "ec2_public_app" {
  name        = "ec2-public-app-sg"
  description = "Allow all inbound traffic for HTTP and trusted IP for SSH"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name      = "ec2-public-app-sg"
    Component = "security"
  }
}

# SG Rule: Allow all HTTP Inbound for EC2 Public App SG
resource "aws_vpc_security_group_ingress_rule" "allow_all_inbound_http_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.ec2_public_app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# SG Rule: Allow all SSH Inbound for EC2 Public App SG
resource "aws_vpc_security_group_ingress_rule" "allow_trusted_inbound_ssh_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.ec2_public_app.id
  cidr_ipv4         = local.trusted_ip
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# SG Rule: Allow all Outbound IPv4 for EC2 Public App SG
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4_ec2_public_app" {
  security_group_id = aws_security_group.ec2_public_app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}