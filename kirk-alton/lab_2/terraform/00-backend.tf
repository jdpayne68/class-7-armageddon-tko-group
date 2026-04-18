# =============================================================================
# FOUNDATION — Remote State Backend Configuration
# =============================================================================

# ----------------------------------------------------------------
# S3 Backend
# ----------------------------------------------------------------
# Backend configuration to sore the state file remotely.
# The bucket can be configured in a different region than the Terraform deployment.

# terraform {
#   backend "s3" {
#     bucket = "kirkdevsecops-terraform-state"
#     key = "class7/terraform/dev/quick-vpc/terraform.tfstate"
#     region = "us-west-2"
#   }
# }