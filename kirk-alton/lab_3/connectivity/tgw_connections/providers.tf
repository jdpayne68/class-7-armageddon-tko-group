# ----------------------------------------------------------------
# GLOBAL — Terraform Configuration
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
  alias  = "tokyo"
  region = "ap-northeast-1"

  default_tags {
    tags = merge(
      {
        ManagedBy = "terraform"
        Component = "network"
        Scope     = "global-peering"
        Region    = "tokyo"
      },
      local.context.tags
    )
  }
}

# ----------------------------------------------------------------
# PROVIDERS — AWS Regional (Sao Paulo)
# ----------------------------------------------------------------

provider "aws" {
  alias  = "saopaulo"
  region = "sa-east-1"

  default_tags {
    tags = merge(
      {
        ManagedBy = "terraform"
        Component = "network"
        Scope     = "global-peering"
        Region    = "saopaulo"
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