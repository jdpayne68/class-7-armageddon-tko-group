# ----------------------------------------------------------------
# DNS — Cloudfront Alias Records (Edge Entrypoint)
# ----------------------------------------------------------------

# Apex Domain → CloudFront Distribution
resource "aws_route53_record" "rds_app_apex_to_cloudfront" {
  zone_id = local.route53_zone_id
  name    = local.root_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.rds_app.domain_name
    zone_id                = aws_cloudfront_distribution.rds_app.hosted_zone_id
    evaluate_target_health = false # Route53 health checks apply to ALB/NLB, not CloudFront.
  }
}

# Application Subdomain → CloudFront Distribution
resource "aws_route53_record" "rds_app_subdomain_to_cloudfront" {
  zone_id = local.route53_zone_id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.rds_app.domain_name
    zone_id                = aws_cloudfront_distribution.rds_app.hosted_zone_id
    evaluate_target_health = false # Route53 health checks apply to ALB/NLB, not CloudFront.
  }
}


# ----------------------------------------------------------------
# DNS — Cloudfront Origin Record (ALB Backend)
# ----------------------------------------------------------------

resource "aws_route53_record" "rds_app_origin_to_alb" {
  zone_id = local.route53_zone_id
  name    = "origin.${local.root_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.rds_app_public_alb.dns_name
    zone_id                = aws_lb.rds_app_public_alb.zone_id
    evaluate_target_health = false
  }
}