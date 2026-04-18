# ----------------------------------------------------------------
# EDGE — CloudFront Response Headers Policies
# ----------------------------------------------------------------

resource "aws_cloudfront_response_headers_policy" "static" {
  provider = aws.edge

  name    = "rds-app-static-response-headers-${var.name_suffix}"
  comment = "Explicit Cache-Control for static assets"

  custom_headers_config {
    items {
      header   = "Cache-Control"
      override = true
      value    = "public, max-age=86400, immutable"
    }
  }
}