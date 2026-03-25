# ----------------------------------------------------------------
# EDGE DEPLOY — Terraform Configuration
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
# PROVIDERS — EDGE (Global: CloudFront / ACM us-east-1)
# ----------------------------------------------------------------
provider "aws" {
  alias  = "edge"
  region = "us-east-1"

  default_tags {
    tags = merge(
      {
        ManagedBy = "terraform"
        Scope     = "edge"
      },
      local.context.tags
    )
  }
}

# ----------------------------------------------------------------
# PROVIDERS — TOKYO (APAC Origin / Hub)
# ----------------------------------------------------------------
provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"

  default_tags {
    tags = merge(
      {
        ManagedBy = "terraform"
        Scope     = "apac"
      },
      local.context.tags
    )
  }
}

# ----------------------------------------------------------------
# PROVIDERS — SAO PAULO (LATAM Origin / Spoke)
# ----------------------------------------------------------------
provider "aws" {
  alias  = "saopaulo"
  region = "sa-east-1"

  default_tags {
    tags = merge(
      {
        ManagedBy = "terraform"
        Scope     = "latam"
      },
      local.context.tags
    )
  }
}

# ----------------------------------------------------------------
# PROVIDERS — Auxiliary
# ----------------------------------------------------------------
provider "random" {}
provider "local" {}

# ----------------------------------------------------------------
# DATA — AWS Account Identity
# ----------------------------------------------------------------
data "aws_caller_identity" "current" {}