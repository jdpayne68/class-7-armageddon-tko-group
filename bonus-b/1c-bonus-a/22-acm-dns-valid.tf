############################################
# ACM DNS Validation Records
############################################

# Explanation: ACM asks “prove you own this planet”—DNS validation is armageddon roaring in the right place.
resource "aws_route53_record" "armageddon_acm_validation_records01" {
  for_each = var.certificate_validation_method == "DNS" ? {
    for dvo in aws_acm_certificate.armageddon_acm_cert01.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}

  zone_id = local.armageddon_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60

  records = [each.value.record]
}


# Explanation: This ties the “proof record” back to ACM—armageddon gets his green checkmark for TLS.
resource "aws_acm_certificate_validation" "armageddon_acm_validation01_dns_bonus" {
  count = var.certificate_validation_method == "DNS" ? 1 : 0

  certificate_arn = aws_acm_certificate.armageddon_acm_cert01.arn

  validation_record_fqdns = [
    for r in aws_route53_record.armageddon_acm_validation_records01 : r.fqdn
  ]
}

