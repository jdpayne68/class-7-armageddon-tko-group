# ----------------------------------------------------------------
# EDGE — CloudFront Origin Request Policies
# ----------------------------------------------------------------

# Managed Policy — Forward All Viewer Headers Except Host
data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  provider = aws.edge

  name = "Managed-AllViewerExceptHostHeader"
}

# Custom Origin Request Policy — Static Assets
resource "aws_cloudfront_origin_request_policy" "static" {
  name    = "rds-app-orp-static-${var.name_suffix}"
  comment = "Minimal forwarding for static assets"

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