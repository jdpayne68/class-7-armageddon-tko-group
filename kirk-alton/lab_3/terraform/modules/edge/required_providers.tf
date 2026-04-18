# ----------------------------------------------------------------
# EDGE / DNS / CDN — Terraform Configuration
# ----------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [
        aws.edge
      ]
    }

    random = {
      source = "hashicorp/random"
    }
  }
}