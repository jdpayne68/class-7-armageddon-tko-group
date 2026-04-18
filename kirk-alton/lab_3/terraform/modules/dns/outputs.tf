# ----------------------------------------------------------------
# DNS — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — Hosted Zone ID
# ----------------------------------------------------------------

output "zone_id" {
  description = "Route53 hosted zone ID."

  value = var.manage_route53_in_terraform ? aws_route53_zone.terraform_managed_zone[0].zone_id : data.aws_route53_zone.rds_app_zone[0].zone_id
}

# ----------------------------------------------------------------
# OUTPUTS — Origin Record (ALB)
# ----------------------------------------------------------------

output "rds_app_origin_record" {
  description = "A record mapping FQDN to ALB."

  value = var.manage_route53_in_terraform ? {
    fqdn    = aws_route53_record.rds_app_origin_to_alb[0].fqdn
    name    = aws_route53_record.rds_app_origin_to_alb[0].name
    zone_id = aws_route53_zone.terraform_managed_zone[0].zone_id
    type    = aws_route53_record.rds_app_origin_to_alb[0].type
    } : {
    fqdn    = null
    name    = null
    zone_id = data.aws_route53_zone.rds_app_zone[0].zone_id
    type    = null
  }
}

# ----------------------------------------------------------------
# OUTPUTS — Hosted Zone Details
# ----------------------------------------------------------------

output "route53_zone" {
  description = "Route53 hosted zone details."

  value = var.manage_route53_in_terraform ? {
    arn          = aws_route53_zone.terraform_managed_zone[0].arn
    id           = aws_route53_zone.terraform_managed_zone[0].zone_id
    name         = aws_route53_zone.terraform_managed_zone[0].name
    name_servers = aws_route53_zone.terraform_managed_zone[0].name_servers
    comment      = aws_route53_zone.terraform_managed_zone[0].comment
    } : {
    arn          = data.aws_route53_zone.rds_app_zone[0].arn
    id           = data.aws_route53_zone.rds_app_zone[0].zone_id
    name         = data.aws_route53_zone.rds_app_zone[0].name
    name_servers = data.aws_route53_zone.rds_app_zone[0].name_servers
    comment      = data.aws_route53_zone.rds_app_zone[0].comment
  }
}