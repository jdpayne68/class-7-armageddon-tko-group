############################################
# Locals (naming convention: armageddon-*)
############################################
locals {
  name_prefix = var.project_name
}

locals {
  # Explanation: Name prefix is the roar that echoes through every tag.
  armageddon_prefix = var.project_name

  # TODO: Students should lock this down after apply using the real secret ARN from outputs/state
  armageddon_secret_arn_guess = "arn:aws:secretsmanager:${data.aws_region.armageddon_region01.id}:${data.aws_caller_identity.armageddon_self01.account_id}:secret:${local.armageddon_prefix}/rds/mysql*"
}


locals {
  # Explanation: armageddon needs a home planet—Route53 hosted zone is your DNS territory.
  armageddon_zone_name = var.domain_name

  # Explanation: Use either Terraform-managed zone or a pre-existing zone ID (students choose their destiny).
  armageddon_zone_id = var.manage_route53_in_terraform ? aws_route53_zone.armageddon_zone01[0].zone_id : var.route53_hosted_zone_id

  # Explanation: This is the app address that will growl at the galaxy (app.armageddon-growl.com).
  armageddon_app_fqdn = "${var.app_subdomain}.${var.domain_name}"
}


locals {
  # Explanation: This is the roar address — where the galaxy finds your app.
  armageddon_fqdn = "${var.app_subdomain}.${var.domain_name}"
}

data "aws_acm_certificate" "issued" {
  domain   = "armageddon.click"
  statuses = ["ISSUED"]
}

# Find a certificate issued by (not imported into) ACM
data "aws_acm_certificate" "amazon_issued" {
  domain      = "armageddon.click"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

locals {
  created_cert_arn = try(aws_acm_certificate_validation.armageddon_acm_validation01_dns_bonus[0].certificate_arn, "")
}

