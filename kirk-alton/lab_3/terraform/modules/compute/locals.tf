# ----------------------------------------------------------------
# COMPUTE — LOCALS
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # TEMPLATES — User Data & Agent Config
  # ----------------------------------------------------------------

  # EC2 user data for app instances
  rds_app_user_data = templatefile(
    "${path.module}/templates/1c_user_data.sh.tpl",
    {
      region      = var.context.region,
      secret_id   = var.db_secret_arn,
      name_suffix = var.name_suffix
    }
  )

  # CloudWatch agent configuration
  cloudwatch_agent_config = templatefile(
    "${path.module}/templates/cloudwatch_agent_config.json.tpl",
    {
      name_suffix = var.name_suffix
    }
  )

  # ----------------------------------------------------------------
  # COMPUTE — AMI Mapping
  # ----------------------------------------------------------------

  # Region → AMI map (fallback or override pattern)
  ami_map = {
    ap-northeast-1 = "ami-aaa111" # Tokyo
    sa-east-1      = "ami-bbb222" # Sao Paulo
  }

  # ----------------------------------------------------------------
  # TLS — ACM Validation
  # ----------------------------------------------------------------

  # Convert set → list and select first validation option
  # Root + wildcard share validation → ensures deterministic plan
  # https://fivexl.io/blog/aws_acm_certificate/
  rds_app_certificate_validation_options = tolist(aws_acm_certificate.rds_app_cert.domain_validation_options)[0]
}