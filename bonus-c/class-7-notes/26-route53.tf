resource "aws_route53_zone" "armageddon_zone01" {
  count = var.manage_route53_in_terraform ? 1 : 0

  name = local.armageddon_zone_name

  tags = {
    Name = "${var.project_name}-zone01"
  }
}

resource "aws_route53_record" "armageddon_acm_validation_records01" {
  for_each = var.certificate_validation_method == "DNS" ? {
    for dvo in aws_acm_certificate.armageddon_acm_cert01.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = local.armageddon_zone_id

}
