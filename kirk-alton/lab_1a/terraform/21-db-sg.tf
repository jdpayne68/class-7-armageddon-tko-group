# Private Database Security Group
resource "aws_security_group" "private_db" {
  name        = "private-db-sg"
  description = "Only allow inbound traffic from ec2-public-app"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name      = "private-db-sg"
    Component = "security"
  }
}

# SG Rule: Allow Aurora/MySQL Inbound only from EC2 Public App SG
resource "aws_vpc_security_group_ingress_rule" "allow_inbound_http_from_ec2_public_app" {
  security_group_id            = aws_security_group.private_db.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.ec2_public_app.id
}

# SG Rule: Allow Outbound IPv4 for Private DB SG
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4_private_db" {
  security_group_id = aws_security_group.private_db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}