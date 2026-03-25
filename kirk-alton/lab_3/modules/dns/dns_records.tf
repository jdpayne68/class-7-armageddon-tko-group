# # ----------------------------------------------------------------
# # DNS — CloudFront Alias Records (Edge Entrypoint)
# # ----------------------------------------------------------------

# # Apex Domain → CloudFront Distribution
# resource "aws_route53_record" "rds_app_apex_to_cloudfront" {
#   provider = aws.regional

#   zone_id = local.route53_zone_id
#   name    = var.dns_context.root_domain
#   type    = "A"

#   alias {
#     name                   = var.cloudfront_distribution.domain_name
#     zone_id                = var.cloudfront_distribution.hosted_zone_id
#     evaluate_target_health = false # Route53 health checks apply to ALB/NLB, not CloudFront.
#   }
# }

# # Application Subdomain → CloudFront Distribution
# resource "aws_route53_record" "rds_app_subdomain_to_cloudfront" {
#   provider = aws.regional

#   zone_id = local.route53_zone_id
#   name    = var.dns_context.fqdn
#   type    = "A"

#   alias {
#     name                   = var.cloudfront_distribution.domain_name
#     zone_id                = var.cloudfront_distribution.hosted_zone_id
#     evaluate_target_health = false # Route53 health checks apply to ALB/NLB, not CloudFront.
#   }
# }

# ----------------------------------------------------------------
# DNS — CloudFront Origin Record (ALB Backend)
# ----------------------------------------------------------------

resource "aws_route53_record" "rds_app_origin_to_alb" {
  count    = var.is_dns_writer ? 1 : 0
  provider = aws.regional

  zone_id = local.route53_zone_id
  name    = "origin.${var.dns_context.root_domain}"
  type    = "A"

  alias {
    name                   = var.rds_app_public_alb_dns_name
    zone_id                = var.rds_app_public_alb_zone_id
    evaluate_target_health = false
  }
}