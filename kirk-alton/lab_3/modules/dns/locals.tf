# ----------------------------------------------------------------
# DNS — LOCALS
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # DNS — Route53 Zone Resolution
  # ----------------------------------------------------------------
  # Tries Terraform-managed hosted zone first.
  # Falls back to existing zone via data source.

  route53_zone_id = coalesce(
    try(aws_route53_zone.terraform_managed_zone[0].zone_id, null),
    data.aws_route53_zone.rds_app_zone[0].zone_id,
    null
  )
}