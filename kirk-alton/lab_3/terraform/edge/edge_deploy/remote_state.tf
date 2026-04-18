# ----------------------------------------------------------------
# EDGE DEPLOY REMOTE STATE — Read Regional Infrastructure: Tokyo
# ----------------------------------------------------------------
# Reads outputs from the Tokyo regional stack.
# Configuration must match the backend settings defined in the Tokyo stack.

data "terraform_remote_state" "tokyo" {
  backend = "s3"

  config = {
    bucket = "kirkdevsecops-terraform-state"
    key    = "rds-app/dev/regions/tokyo/terraform.tfstate"
    region = "us-west-2"
  }
}

# ----------------------------------------------------------------
# EDGE DEPLOY REMOTE STATE — Read Regional Infrastructure: SAO PAULO
# ----------------------------------------------------------------
# Reads outputs from the Sao Paulo regional stack.
# Configuration must match the backend settings defined in the Sao Paulo stack.
data "terraform_remote_state" "saopaulo" {
  backend = "s3"

  config = {
    bucket = "kirkdevsecops-terraform-state"
    key    = "rds-app/dev/regions/sao_paulo/terraform.tfstate"
    region = "us-west-2"
  }
}