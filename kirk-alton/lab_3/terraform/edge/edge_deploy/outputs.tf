# ----------------------------------------------------------------
# EDGE DEPLOY — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# ACCESS — Application Entry Point
# ----------------------------------------------------------------

output "application_url" {
  description = "Application HTTPS URL served via CloudFront."
  value       = module.edge.application_url.url
}

# ----------------------------------------------------------------
# EDGE — CloudFront Distribution
# ----------------------------------------------------------------

output "cloudfront_distribution" {
  description = "CloudFront distribution details."

  value = {
    id             = module.edge.cloudfront_distribution.id
    arn            = module.edge.cloudfront_distribution.arn
    domain_name    = module.edge.cloudfront_distribution.domain_name
    hosted_zone_id = module.edge.cloudfront_distribution.hosted_zone_id
    status         = module.edge.cloudfront_distribution.status
  }
}