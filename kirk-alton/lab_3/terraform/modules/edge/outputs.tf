# ----------------------------------------------------------------
# EDGE — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — TLS (CloudFront ACM)
# ----------------------------------------------------------------

output "rds_app_cf_cert_domain_validation_options" {
  description = "CloudFront ACM validation options."
  value       = aws_acm_certificate.rds_app_cf_cert.domain_validation_options
}

output "rds_app_cf_cert_arn" {
  description = "CloudFront ACM certificate ARN."
  value       = aws_acm_certificate.rds_app_cf_cert.arn
}

# ----------------------------------------------------------------
# OUTPUTS — Application Access
# ----------------------------------------------------------------

output "application_url" {
  description = "Application HTTPS URL."

  value = {
    url = "https://${var.dns_context.fqdn}"
  }
}

# ----------------------------------------------------------------
# OUTPUTS — CloudFront (Control Plane)
# ----------------------------------------------------------------

output "cloudfront_distribution" {
  description = "CloudFront distribution details."

  value = {
    id             = aws_cloudfront_distribution.rds_app.id
    arn            = aws_cloudfront_distribution.rds_app.arn
    domain_name    = aws_cloudfront_distribution.rds_app.domain_name
    hosted_zone_id = aws_cloudfront_distribution.rds_app.hosted_zone_id
    status         = aws_cloudfront_distribution.rds_app.status
  }
}

output "cloudfront_tls" {
  description = "CloudFront TLS configuration."

  value = {
    certificate_arn          = aws_acm_certificate.rds_app_cf_cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

# ----------------------------------------------------------------
# OUTPUTS — CloudFront (Public Endpoints)
# ----------------------------------------------------------------

output "cloudfront_endpoints" {
  description = "Public CloudFront endpoints."

  value = {
    apex_domain     = var.dns_context.root_domain
    subdomain       = var.dns_context.fqdn
    cloudfront_host = aws_cloudfront_distribution.rds_app.domain_name
  }
}

# ----------------------------------------------------------------
# OUTPUTS — CloudFront (Origin)
# ----------------------------------------------------------------

output "edge_auth_value" {
  description = "Edge auth header value."
  value       = var.edge_auth_value
}

output "cloudfront_origin" {
  description = "CloudFront origin configuration."

  value = {
    origin_domain          = "origin.${var.dns_context.root_domain}"
    origin_protocol_policy = "https-only"
  }
}

output "cloudfront_domain" {
  description = "CloudFront domain name."
  value       = aws_cloudfront_distribution.rds_app.domain_name
}