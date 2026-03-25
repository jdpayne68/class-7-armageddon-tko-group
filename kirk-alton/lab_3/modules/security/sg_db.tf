# ----------------------------------------------------------------
# SECURITY — Database Security Group
# ----------------------------------------------------------------

resource "aws_security_group" "private_db" {
  provider = aws.regional

  name        = "private-db-sg"
  description = "Only allow inbound traffic from ec2-rds-app"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name      = "private-db-sg"
      Component = "security"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# SECURITY — Database Ingress Rules (Application Tier)
# ----------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_http_from_ec2_internal_app" {
  provider = aws.regional

  security_group_id            = aws_security_group.private_db.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.rds_app_asg.id
}

# ----------------------------------------------------------------
# SECURITY — Database Egress Rules
# ----------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4_private_db" {
  provider = aws.regional

  security_group_id = aws_security_group.private_db.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}