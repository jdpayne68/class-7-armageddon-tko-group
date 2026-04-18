# ----------------------------------------------------------------
# SAO PAULO BACKEND — Terraform Backend Configuration (S3)
# ----------------------------------------------------------------
# Uses platform-managed bootstrap infrastructure (S3 backend and lockfile).

terraform {
  backend "s3" {
    bucket       = "kirkdevsecops-terraform-state"
    key          = "rds-app/dev/regions/sao_paulo/terraform.tfstate" # Update app, env and region before deploying: {app}/{env}/regions/{region}/terraform.tfstate
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true # Always explicitly declare encryption, even if already applied on platform.
  }
}