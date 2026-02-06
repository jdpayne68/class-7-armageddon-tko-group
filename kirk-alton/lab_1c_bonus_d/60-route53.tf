# ACM Certificate for RDS App
resource "aws_acm_certificate" "rds_app_cert" {
  domain_name               = local.root_domain
  subject_alternative_names = ["*.${local.root_domain}"] # Use wildcard to cover one level subdomains (argument value requires a set of strings here)
  validation_method         = "DNS"

  tags = {
    Name = "${local.application}-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Hosted Zone for RDS App
data "aws_route53_zone" "rds_app_zone" { # Use data if the zone already exists. Use resource if you want to create a new zone.
  name         = local.root_domain
  private_zone = false
}

# DNS Validation Records for ACM Certificate
resource "aws_route53_record" "rds_app_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.rds_app_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.rds_app_zone.id
}

# ACM Certificate Validation
resource "aws_acm_certificate_validation" "rds_app_cert" {
  certificate_arn         = aws_acm_certificate.rds_app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.rds_app_cert_validation : record.fqdn]
}

# A record for RDS App on Sub Domain
resource "aws_route53_record" "rds_app_alias" {
  zone_id = data.aws_route53_zone.rds_app_zone.id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = aws_lb.rds_app_public_alb.dns_name
    zone_id                = aws_lb.rds_app_public_alb.zone_id
    evaluate_target_health = true
  }
}

# A record for RDS App on Apex Domain
resource "aws_route53_record" "rds_app_apex_alias" {
  zone_id = data.aws_route53_zone.rds_app_zone.zone_id
  name    = local.root_domain
  type    = "A"

  alias {
    name                   = aws_lb.rds_app_public_alb.dns_name
    zone_id                = aws_lb.rds_app_public_alb.zone_id
    evaluate_target_health = true
  }
}
