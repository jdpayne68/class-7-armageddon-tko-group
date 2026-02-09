# ACM Certificate for RDS App
resource "aws_acm_certificate" "rds_app_cert" {
  domain_name               = local.root_domain
  subject_alternative_names = ["*.${local.root_domain}"] # Use wildcard to cover one level subdomains (argument value requires a set of strings here)
  validation_method         = "DNS"

  tags = {
    Name = "${local.app}-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ACM Certificate Validation
resource "aws_acm_certificate_validation" "rds_app_cert" {
  certificate_arn         = aws_acm_certificate.rds_app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.rds_app_cert_validation : record.fqdn]
}
