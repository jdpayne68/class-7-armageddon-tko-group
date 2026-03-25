# ----------------------------------------------------------------
# COMPUTE - ACM Certificate (ALB)
# ----------------------------------------------------------------
# Regional TLS Certificate
resource "aws_acm_certificate" "rds_app_cert" {
  provider = aws.regional

  domain_name               = var.dns_context.root_domain
  subject_alternative_names = ["*.${var.dns_context.root_domain}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.context.app}-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------------------------------------------------
# COMPUTE - DNS Validation Records for ACM Certificate (ALB)
# -------------------------------------------------------------------
resource "aws_route53_record" "rds_app_cert_validation" {
  provider = aws.regional

  # ACM domain_validation_options is unknown at plan time and returned as a set.
  # Use a single deterministic record via locals (first element) to avoid for_each instability.
  # https://fivexl.io/blog/aws_acm_certificate/

  allow_overwrite = true

  name    = local.rds_app_certificate_validation_options.resource_record_name
  records = [local.rds_app_certificate_validation_options.resource_record_value]
  type    = local.rds_app_certificate_validation_options.resource_record_type
  ttl     = 60


  zone_id = var.zone_id
}

# ----------------------------------------------------------------
# COMPUTE — ACM Certificate Validation (ALB)
# ----------------------------------------------------------------
# DNS Validation
resource "aws_acm_certificate_validation" "rds_app_cert" {
  provider = aws.regional

  # This resource enforces ordering: Terraform waits until DNS validation completes
  certificate_arn = aws_acm_certificate.rds_app_cert.arn

  validation_record_fqdns = [
    aws_route53_record.rds_app_cert_validation.fqdn
  ]
}