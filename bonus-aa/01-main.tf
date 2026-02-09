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
