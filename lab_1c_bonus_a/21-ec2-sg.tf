# EC2 Public App Security Group
resource "aws_security_group" "rds_app_ec2" {
  name        = "rds-app-sg"
  description = "Allow all internal inbound traffic for HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name      = "rds-app-ec2-sg"
    Component = "security"
  }
}


# SG Rule: Allow HTTPS Outbound to VPC Endpoints
resource "aws_vpc_security_group_ingress_rule" "allow_https_vpc_endpoints" {
  security_group_id            = aws_security_group.rds_app_ec2.id
  ip_protocol                  = "tcp"
  to_port                      = 443
  from_port                    = 443
  referenced_security_group_id = aws_security_group.vpc_endpoints.id

}

resource "aws_vpc_security_group_egress_rule" "allow_all_internal_outbound_ipv4_rds_app_ec2" {
  security_group_id = aws_security_group.rds_app_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}