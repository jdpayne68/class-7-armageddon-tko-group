# ----------------------------------------------------------------
# TGW PEERING — Terraform Configuration
# ----------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [
        aws.source,
        aws.peer
      ]
    }
  }
}

# # ----------------------------------------------------------------
# # TGW PEERING — Providers (Source / Peer Regions)
# # ----------------------------------------------------------------

# provider "aws" {
#   alias = "source"
# }

# provider "aws" {
#   alias = "peer"
# }