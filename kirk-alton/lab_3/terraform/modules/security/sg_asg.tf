# ----------------------------------------------------------------
# SECURITY — Application Auto Scaling Group Security Group
# ----------------------------------------------------------------

resource "aws_security_group" "rds_app_asg" {
  provider = aws.regional

  name        = "rds-app-asg-sg"
  description = "Only allow inbound traffic from public-application-lb-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "private-asg-sg"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# SECURITY — ASG Ingress Rules (From ALB)
# ----------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_http_from_public_alb_sg" {
  provider = aws.regional

  security_group_id            = aws_security_group.rds_app_asg.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.alb_origin.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_https_from_public_alb_sg" {
  provider = aws.regional

  security_group_id            = aws_security_group.rds_app_asg.id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.alb_origin.id
}

# ----------------------------------------------------------------
# SECURITY — ASG Egress Rules
# ----------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "allow_all_internal_outbound_ipv4_rds_app_asg" {
  provider = aws.regional

  security_group_id = aws_security_group.rds_app_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}