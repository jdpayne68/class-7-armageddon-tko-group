# ----------------------------------------------------------------
# DNS — CloudFront Alias Records (Edge Entrypoint)
# ----------------------------------------------------------------

# Apex Domain → CloudFront Distribution
resource "aws_route53_record" "rds_app_apex_to_cloudfront" {
  provider = aws.edge

  zone_id = var.zone_id
  name    = var.dns_context.root_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.rds_app.domain_name
    zone_id                = aws_cloudfront_distribution.rds_app.hosted_zone_id
    evaluate_target_health = false # Route53 health checks apply to ALB/NLB, not CloudFront.
  }
}

# Application Subdomain → CloudFront Distribution
resource "aws_route53_record" "rds_app_subdomain_to_cloudfront" {
  provider = aws.edge

  zone_id = var.zone_id
  name    = var.dns_context.fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.rds_app.domain_name
    zone_id                = aws_cloudfront_distribution.rds_app.hosted_zone_id
    evaluate_target_health = false # Route53 health checks apply to ALB/NLB, not CloudFront.
  }
}