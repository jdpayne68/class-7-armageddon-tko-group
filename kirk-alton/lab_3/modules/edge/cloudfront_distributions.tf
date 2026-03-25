# ----------------------------------------------------------------
# EDGE — CloudFront Distribution
# ----------------------------------------------------------------

resource "aws_cloudfront_distribution" "rds_app" {
  provider = aws.edge

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "rds-app-cloudfront-${var.name_suffix}"
  default_root_object = ""

  depends_on = [
    aws_acm_certificate_validation.rds_app_cf_cert
  ]

  origin {
    origin_id   = "rds-app-alb-origin"
    domain_name = "origin.${var.dns_context.root_domain}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = var.edge_auth_header_name
      value = var.edge_auth_value
    }
  }

  default_cache_behavior {
    target_origin_id       = "rds-app-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  ordered_cache_behavior {
    path_pattern           = "/api/public-feed"
    target_origin_id       = "rds-app-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.use_origin_cache_control.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "rds-app-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  ordered_cache_behavior {
    path_pattern           = "/static/*"
    target_origin_id       = "rds-app-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id            = aws_cloudfront_cache_policy.cache_static.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.static.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.static.id
  }

  # viewer_certificate {
  #   acm_certificate_arn      = aws_acm_certificate.rds_app_cf_cert.arn
  #   ssl_support_method       = "sni-only"
  #   minimum_protocol_version = "TLSv1.2_2021"
  # }

  viewer_certificate {
    # Use the validated certificate ARN to ensure the cert is issued before CloudFront uses it.
    acm_certificate_arn      = aws_acm_certificate_validation.rds_app_cf_cert.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  aliases = [
    var.dns_context.root_domain,
    var.dns_context.fqdn
  ]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}