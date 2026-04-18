# FOUNDATION — Terraform & Provider Configuration
# =============================================================================

# ----------------------------------------------------------------
# Required Providers
# ----------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.18.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

# ----------------------------------------------------------------
# AWS Provider — Regional (Application Infrastructure)
# ----------------------------------------------------------------
provider "aws" {
  region  = local.region
  profile = "default" # Uses AWS credentials from [default] profile in ~/.aws/credentials

  default_tags {
    tags = {
      ManagedBy   = "terraform"
      Environment = local.env
      Application = local.app
    }
  }
}

# ----------------------------------------------------------------
# AWS Provider — Global Services
# ----------------------------------------------------------------
provider "aws" {
  alias  = "global"
  region = "us-east-1"

  default_tags {
    tags = {
      ManagedBy   = "terraform"
      Environment = local.env
      Application = local.app
      Scope       = "global-edge"
    }
  }
}

# ----------------------------------------------------------------
# Auxillary Providers
# ----------------------------------------------------------------
provider "local" {}

provider "random" {}

# ----------------------------------------------------------------
# Account Identity (Data Source)
# ----------------------------------------------------------------
data "aws_caller_identity" "current" {}
