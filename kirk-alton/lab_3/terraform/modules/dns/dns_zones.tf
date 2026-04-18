# ----------------------------------------------------------------
# DNS — Hosted Zones
# ----------------------------------------------------------------

# Optional Terraform-managed Hosted Zone
resource "aws_route53_zone" "terraform_managed_zone" {
  provider = aws.regional

  count = var.manage_route53_in_terraform ? 1 : 0

  name = var.dns_context.root_domain
}

# Existing Hosted Zone Lookup
data "aws_route53_zone" "rds_app_zone" {
  provider = aws.regional

  count = var.manage_route53_in_terraform ? 0 : 1

  name         = var.dns_context.root_domain
  private_zone = false
}