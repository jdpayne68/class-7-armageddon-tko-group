# ================================================================
# EDGE — Cloudfront Policies
# ================================================================

# ----------------------------------------------------------------
# EDGE — Cloudfront Managed Cache Policies (Data Sources)
# ----------------------------------------------------------------
# Managed Policy — Disable Caching (Dynamic / API)
data "aws_cloudfront_cache_policy" "caching_disabled" {
  provider = aws.global
  name     = "Managed-CachingDisabled"
}

# Managed Policy — Use Origin Cache-Control Headers
data "aws_cloudfront_cache_policy" "use_origin_cache_control" {
  provider = aws.global
  name     = "UseOriginCacheControlHeaders"
}

# Managed Policy — Forward All Viewer Headers Except Host
data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  provider = aws.global
  name     = "Managed-AllViewerExceptHostHeader"
}

# ----------------------------------------------------------------
# EDGE — Cloudfront Response Headers Policy (Static)
# ----------------------------------------------------------------

resource "aws_cloudfront_response_headers_policy" "static" {
  provider = aws.global
  name     = "rds-app-static-response-headers-${local.name_suffix}"
  comment  = "Explicit Cache-Control for static assets"

  custom_headers_config {
    items {
      header   = "Cache-Control"
      override = true
      value    = "public, max-age=86400, immutable"
    }
  }
}


# ----------------------------------------------------------------
# EDGE — Cloudfront Cache Policy (Static Assets)
# ----------------------------------------------------------------

resource "aws_cloudfront_cache_policy" "cache_static" {
  provider    = aws.global
  name        = "rds-app-cache-static-${local.name_suffix}"
  comment     = "Aggressive caching for /static/*"
  default_ttl = 86400    # 1 day
  max_ttl     = 31536000 # 1 year
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {

    cookies_config {
      cookie_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}

# ----------------------------------------------------------------
# EDGE — Cloudfront Origin Request Policy (Static Assets)
# ----------------------------------------------------------------

resource "aws_cloudfront_origin_request_policy" "static" {
  provider = aws.global
  name     = "rds-app-orp-static-${local.name_suffix}"
  comment  = "Minimal forwarding for static assets"

  cookies_config {
    cookie_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }

  headers_config {
    header_behavior = "none"
  }
}


# ================================================================
# EDGE — Distribution (ALB)
# ================================================================

# ----------------------------------------------------------------
# EDGE — Cloudfront Distribution (ALB Origin)
# ----------------------------------------------------------------
resource "aws_cloudfront_distribution" "rds_app" {
  provider            = aws.global
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "rds-app-cloudfront-${local.name_suffix}"
  default_root_object = ""

  depends_on = [
    aws_acm_certificate_validation.rds_app_cf_cert
  ]

  # ---------------------------
  # Origin — ALB
  # ---------------------------
  origin {
    origin_id   = "rds-app-alb-origin"
    domain_name = "origin.${local.root_domain}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    # Secret origin header (must match your ALB listener rule)
    custom_header {
      name  = local.edge_auth_header_name
      value = random_password.edge_auth_value.result
    }
  }

  # ---------------------------
  # Default Cache Behavior
  # ---------------------------
  default_cache_behavior {

    target_origin_id       = "rds-app-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  # ----------------------------------------------------------------
  # Ordered Cache Behavior — API Public Feed (Origin-Driven Caching)
  # ----------------------------------------------------------------
  ordered_cache_behavior {
    path_pattern           = "/api/public-feed"
    target_origin_id       = "rds-app-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.use_origin_cache_control.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  # ----------------------------------------------------------------
  # Ordered Cache Behavior — API Default (Caching Disabled/Fallback)
  # ----------------------------------------------------------------
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "rds-app-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  # ----------------------------------------------------------------
  # Ordered Cache Behavior — Static Assets (Aggressive Edge Caching)
  # ----------------------------------------------------------------
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

  # ---------------------------
  # TLS Config
  # ---------------------------
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.rds_app_cf_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # ---------------------------
  # Domain Aliases
  # ---------------------------
  aliases = [
    local.root_domain,
    local.fqdn
  ]

  # ---------------------------
  # Geo Restrictions
  # ---------------------------
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Optional: Attach WAF at the CloudFront layer (recommended)
  # web_acl_id = aws_wafv2_web_acl.rds_app.arn
}