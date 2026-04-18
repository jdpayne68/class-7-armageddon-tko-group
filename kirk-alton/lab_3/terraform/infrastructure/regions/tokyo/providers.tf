# ----------------------------------------------------------------
# TOKYO — Terraform Configuration
# ----------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.18.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }

    local = {
      source = "hashicorp/local"
    }
  }
}

# ----------------------------------------------------------------
# PROVIDERS — AWS Regional (Tokyo)
# ----------------------------------------------------------------

provider "aws" {
  region = var.region

  default_tags {
    tags = merge(
      {
        ManagedBy = "terraform"
        Component = "network"
      },
      local.context.tags
    )
  }
}

# ----------------------------------------------------------------
# PROVIDERS — Auxiliary
# ----------------------------------------------------------------

provider "local" {}

provider "random" {}

# ----------------------------------------------------------------
# DATA — AWS Account Identity
# ----------------------------------------------------------------

data "aws_caller_identity" "current" {}