# ----------------------------------------------------------------
# DATA — CloudFront Origin-Facing Prefix List
# ----------------------------------------------------------------

data "aws_ec2_managed_prefix_list" "cloudfront_origin_facing" {
  provider = aws.regional

  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# ----------------------------------------------------------------
# SECURITY — Application Load Balancer Security Group
# ----------------------------------------------------------------

resource "aws_security_group" "alb_origin" {
  provider = aws.regional

  name        = "alb-sg"
  description = "Allow HTTPS only from CloudFront origin-facing prefix list"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "public-application-lb-sg"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# SECURITY — ALB Ingress Rules (CloudFront Origin Only)
# ----------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "allow_https_from_cloudfront" {
  provider = aws.regional

  security_group_id = aws_security_group.alb_origin.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.cloudfront_origin_facing.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

# ----------------------------------------------------------------
# SECURITY — ALB Egress Rules (Tier Trust)
# ----------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4_public_alb" {
  provider = aws.regional

  security_group_id            = aws_security_group.alb_origin.id
  ip_protocol                  = "tcp"
  from_port                    = 0     # FIXME
  to_port                      = 65535 # FIXME
  referenced_security_group_id = aws_security_group.rds_app_asg.id
}