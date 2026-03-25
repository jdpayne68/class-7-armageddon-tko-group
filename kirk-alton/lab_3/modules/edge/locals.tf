# ----------------------------------------------------------------
# EDGE — LOCALS
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # TLS — ACM Validation (CloudFront)
  # ----------------------------------------------------------------
  # Convert set → list and select first validation option (root/wildcard share validation)
  # Ensures deterministic plan without dynamic for_each
  # https://fivexl.io/blog/aws_acm_certificate/

  rds_app_cf_certificate_validation_options = tolist(aws_acm_certificate.rds_app_cf_cert.domain_validation_options)[0]
}