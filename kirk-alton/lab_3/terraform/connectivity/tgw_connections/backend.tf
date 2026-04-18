# ----------------------------------------------------------------
# TGW CONNECTIONS BACKEND — Terraform Backend Configuration (S3)
# ----------------------------------------------------------------
# Uses platform-managed bootstrap infrastructure (S3 backend and lockfile).

terraform {
  backend "s3" {
    bucket       = "kirkdevsecops-terraform-state"
    key          = "rds-app/dev/tgw-connections/terraform.tfstate" # Update app and env before deploying: {app}/{env}/global/terraform.tfstate
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true # Always explicitly declare encryption, even if already applied on platform.
  }
}