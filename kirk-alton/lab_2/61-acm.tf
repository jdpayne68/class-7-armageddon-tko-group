# ================================================================
# EDGE — ACM CERTIFICATE
# ================================================================

# ----------------------------------------------------------------
# EDGE / TLS — ACM Certificate (CloudFront)
# ----------------------------------------------------------------
resource "aws_acm_certificate" "rds_app_cf_cert" {
  provider                  = aws.global # us-east-1 required for CloudFront
  domain_name               = local.root_domain
  subject_alternative_names = ["*.${local.root_domain}"] # Use wildcard to cover one level subdomains
  validation_method         = "DNS"

  tags = {
    Name = "${local.app}-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------
# EDGE / TLS — ACM Certificate Validation (CloudFront)
# ----------------------------------------------------------------
resource "aws_acm_certificate_validation" "rds_app_cf_cert" {
  provider                = aws.global
  certificate_arn         = aws_acm_certificate.rds_app_cf_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.rds_app_cf_cert_validation : record.fqdn]
}



# ================================================================
# REGIONAL — ACM CERTIFICATE
# ================================================================

# ----------------------------------------------------------------
# REGIONAL — ACM Certificate (ALB)
# ----------------------------------------------------------------
resource "aws_acm_certificate" "rds_app_cert" {
  domain_name               = local.root_domain
  subject_alternative_names = ["*.${local.root_domain}"] # Use wildcard to cover one level subdomains
  validation_method         = "DNS"

  tags = {
    Name = "${local.app}-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}


# ----------------------------------------------------------------
# REGIONAL — ACM Certificate Validation (ALB)
# ----------------------------------------------------------------
resource "aws_acm_certificate_validation" "rds_app_cert" {
  certificate_arn         = aws_acm_certificate.rds_app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.rds_app_cert_validation : record.fqdn]
}