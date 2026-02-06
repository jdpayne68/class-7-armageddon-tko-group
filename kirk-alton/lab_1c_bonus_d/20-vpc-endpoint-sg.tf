# VPC EndpointSecurity Group
resource "aws_security_group" "vpc_endpoints" {
  name        = "vpc-endpoints-sg"
  description = "Allow EC2 to reach VPC endpoints"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name      = "vpc-endpoints-sg"
    Component = "security"
  }
}

# SG Rule: Allow Internal HTTPS Inbound from EC2 RDS App SG
resource "aws_vpc_security_group_ingress_rule" "allow_internal_app_https_to_vpc_endpoint" {
  security_group_id = aws_security_group.vpc_endpoints.id
  cidr_ipv4         = local.vpc_cidr
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

# SG Rule: Allow all Outbound IPv4 for VPC Endpoint SG
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_from_vpc_endpoint" {
  security_group_id = aws_security_group.vpc_endpoints.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}