# Conditional Hosted Zone Resource for RDS App
resource "aws_route53_zone" "terraform_managed_zone" {
  count = var.manage_route53_in_terraform ? 1 : 0

  name = local.root_domain
}


# Hosted Zone Data for RDS App
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
  zone_id         = data.aws_route53_zone.rds_app_zone.zone_id
}

# Alias record for RDS App on Sub Domain
resource "aws_route53_record" "rds_app_alias" {
  zone_id = data.aws_route53_zone.rds_app_zone.zone_id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = aws_lb.rds_app_public_alb.dns_name
    zone_id                = aws_lb.rds_app_public_alb.zone_id
    evaluate_target_health = true
  }
}

# Alias record for RDS App on Apex Domain
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