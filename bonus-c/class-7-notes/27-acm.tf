resource "aws_acm_certificate" "armageddon_acm_cert01" {
  domain_name       = local.armageddon_app_fqdn
  validation_method = var.certificate_validation_method

  tags = {
    Name = "${var.project_name}-acm-cert01"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "example" {
  name         = "armageddon.click"
  private_zone = false
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.example.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}


resource "aws_acm_certificate_validation" "armageddon_acm_validation01" {
  certificate_arn = aws_acm_certificate.armageddon_acm_cert01.arn

  # TODO: if using DNS validation, students must pass validation_record_fqdns
  # validation_record_fqdns = [aws_route53_record.armageddon_acm_validation.fqdn]
}

resource "aws_acm_certificate_validation" "armageddon_acm_validation01_dns_bonus" {
  count = var.certificate_validation_method == "DNS" ? 1 : 0

  certificate_arn = aws_acm_certificate.armageddon_acm_cert01.arn

  validation_record_fqdns = [
    for r in aws_route53_record.armageddon_acm_validation_records01 : r.fqdn
  ]
}


