# Private ASG Security Group
resource "aws_security_group" "rds_app_asg" {
  name        = "rds-app-asg-sg"
  description = "Only allow inbound traffic from public-application-lb-sg"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "private-asg-sg"
  }
}

# SG Rule: Allow HTTP Inbound from Public ALB SG
resource "aws_vpc_security_group_ingress_rule" "allow_inbound_http_from_public_alb_sg" {
  security_group_id            = aws_security_group.rds_app_asg.id
  ip_protocol                  = "tcp"
  to_port                      = 80
  from_port                    = 80
  referenced_security_group_id = aws_security_group.alb.id
}

# SG Rule: Allow HTTPS Inbound from Public ALB SG
resource "aws_vpc_security_group_ingress_rule" "allow_inbound_https_from_public_alb_sg" {
  security_group_id            = aws_security_group.rds_app_asg.id
  ip_protocol                  = "tcp"
  to_port                      = 443
  from_port                    = 443
  referenced_security_group_id = aws_security_group.alb.id
}

# # SG Rule: Allow HTTPS Outbound to VPC Endpoints
# resource "aws_vpc_security_group_ingress_rule" "allow_https_vpc_endpoints" {
#   security_group_id            = aws_security_group.rds_app_asg.id
#   ip_protocol                  = "tcp"
#   to_port                      = 443
#   from_port                    = 443
#   referenced_security_group_id = aws_security_group.vpc_endpoints.id

# }

resource "aws_vpc_security_group_egress_rule" "allow_all_internal_outbound_ipv4_rds_app_asg" {
  security_group_id = aws_security_group.rds_app_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}