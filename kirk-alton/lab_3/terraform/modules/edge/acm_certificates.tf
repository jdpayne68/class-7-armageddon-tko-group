# ----------------------------------------------------------------
# EDGE — ACM Certificate (CloudFront)
# ----------------------------------------------------------------
# CloudFront TLS Certificate
resource "aws_acm_certificate" "rds_app_cf_cert" {
  provider = aws.edge

  domain_name               = var.dns_context.root_domain
  subject_alternative_names = ["*.${var.dns_context.root_domain}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.context.app}-cf-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------
# EDGE — DNS Validation Records for CloudFront
# ----------------------------------------------------------------
resource "aws_route53_record" "rds_app_cf_cert_validation" {
  provider = aws.edge

  # ACM domain_validation_options is unknown at plan time and returned as a set.
  # Use a single deterministic record via locals (first element) to avoid for_each instability.
  # https://fivexl.io/blog/aws_acm_certificate/

  allow_overwrite = true

  name    = local.rds_app_cf_certificate_validation_options.resource_record_name
  records = [local.rds_app_cf_certificate_validation_options.resource_record_value]
  type    = local.rds_app_cf_certificate_validation_options.resource_record_type
  ttl     = 60

  zone_id = var.zone_id
}

# ----------------------------------------------------------------
# EDGE — ACM Certificate Validation (CloudFront)
# ----------------------------------------------------------------
# DNS Validation
resource "aws_acm_certificate_validation" "rds_app_cf_cert" {
  provider = aws.edge

  # Ensures Terraform waits for DNS validation before using cert
  certificate_arn = aws_acm_certificate.rds_app_cf_cert.arn

  validation_record_fqdns = [
    aws_route53_record.rds_app_cf_cert_validation.fqdn
  ]
}



# # ----------------------------------------------------------------
# # EDGE — ACM Certificate (CloudFront)
# # ----------------------------------------------------------------
# # CloudFront TLS Certificate

# resource "aws_acm_certificate" "rds_app_cf_cert" {
#   provider = aws.regional

#   domain_name               = var.dns_context.root_domain
#   subject_alternative_names = ["*.${var.dns_context.root_domain}"] # Use wildcard to cover one level subdomains
#   validation_method         = "DNS"

#   tags = {
#     Name = "${var.context.app}-cf-cert"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }


# # ----------------------------------------------------------------
# # EDGE — DNS Validation Records for CloudFront
# # ----------------------------------------------------------------
# resource "aws_route53_record" "rds_app_cf_cert_validation" {
#   provider = aws.regional

#   # ACM may return duplicate validation records (e.g., root + wildcard domains).
#   # Use grouping (...) to avoid duplicate key errors in for_each.
#   for_each = {
#     for dvo in aws_acm_certificate.rds_app_cf_cert.domain_validation_options :
#     dvo.resource_record_name => dvo...
#   }

#   allow_overwrite = true

#   # When grouping is used, each.value is a list. Reference the first element.
#   name    = each.value[0].resource_record_name
#   records = [each.value[0].resource_record_value]
#   ttl     = 60
#   type    = each.value[0].resource_record_type

#   zone_id = var.zone_id
# }


# # ----------------------------------------------------------------
# # EDGE — ACM Certificate Validation (CloudFront)
# # ----------------------------------------------------------------
# # DNS Validation
# resource "aws_acm_certificate_validation" "rds_app_cf_cert" {
#   provider = aws.regional

#   certificate_arn = aws_acm_certificate.rds_app_cf_cert.arn

#   validation_record_fqdns = [
#     for record in aws_route53_record.rds_app_cf_cert_validation :
#     record.fqdn
#   ]
# }