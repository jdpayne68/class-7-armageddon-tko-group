# ----------------------------------------------------------------
# DATA — Cloudfront Origin-facing Prefix List
# ----------------------------------------------------------------

data "aws_ec2_managed_prefix_list" "cloudfront_origin_facing" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# ----------------------------------------------------------------
# SECURITY — Public Alb Security Group
# ----------------------------------------------------------------

# Public Application Load Balancer Security Group
resource "aws_security_group" "alb_origin" {
  name        = "alb-sg"
  description = "Allow HTTPS only from CloudFront origin-facing prefix list"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "public-application-lb-sg"
  }
}


# ----------------------------------------------------------------
# SECURITY — ALB Ingress Rules (Cloudfront Origin Only)
# ----------------------------------------------------------------

# Allow HTTPS from CloudFront origin-facing IP ranges
resource "aws_vpc_security_group_ingress_rule" "allow_https_from_cloudfront" {
  security_group_id = aws_security_group.alb_origin.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.cloudfront_origin_facing.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}



# ----------------------------------------------------------------
# SECURITY — ALB Egress Rules (tier Trust)
# ----------------------------------------------------------------

# SG Rule: Only Allow Outbound IPv4 to RDS App ASG SG
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4_public_alb" {
  security_group_id            = aws_security_group.alb_origin.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.rds_app_asg.id
}