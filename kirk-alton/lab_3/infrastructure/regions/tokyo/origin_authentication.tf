# ----------------------------------------------------------------
# TOKYO ORIGIN SECURITY — CloudFront Origin Authentication Secret
# ----------------------------------------------------------------
# Secret header value used to authenticate CloudFront requests
# to the ALB origin. The ALB listener validates this header to
# ensure traffic only originates from the CloudFront distribution.
# Secret header value used for CloudFront → ALB verification
resource "random_password" "edge_auth_value" {
  length  = 32
  special = false
}