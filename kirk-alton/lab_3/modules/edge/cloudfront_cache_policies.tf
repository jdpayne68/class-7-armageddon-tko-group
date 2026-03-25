# ----------------------------------------------------------------
# EDGE — CloudFront Cache Policies
# ----------------------------------------------------------------

# Managed Policy — Disable Caching (Dynamic / API)
data "aws_cloudfront_cache_policy" "caching_disabled" {
  provider = aws.edge

  name = "Managed-CachingDisabled"
}

# Managed Policy — Use Origin Cache-Control Headers
data "aws_cloudfront_cache_policy" "use_origin_cache_control" {
  name = "UseOriginCacheControlHeaders"
}

# Custom Cache Policy — Static Assets
resource "aws_cloudfront_cache_policy" "cache_static" {
  provider = aws.edge

  name    = "rds-app-cache-static-${var.name_suffix}"
  comment = "Aggressive caching for /static/*"

  default_ttl = 86400
  max_ttl     = 31536000
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