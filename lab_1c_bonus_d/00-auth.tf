# Required providers
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

# Provider configurations

provider "aws" {
  # Configuration options
  region  = local.region
  profile = "default" # Uses AWS credentials from [default] profile in ~/.aws/credentials

  default_tags {
    tags = {
      ManagedBy   = "terraform"
      Environment = "${local.environment}"
      Application = "${local.application}"
    }
  }
}

provider "local" {
  # Configuration options
}
provider "random" {
  # Configuration options
}

# Backend configuration to sore the state file remotely. Replace with your own backend info.
# The bucket can be configured in a different region than the Terraform deployment.
# terraform {
#   backend "s3" {
#     bucket = "kirkdevsecops-terraform-state"
#     key = "class7/terraform/dev/quick-vpc/terraform.tfstate"
#     region = "us-west-2"
#   }
# }

# Data for Current Account ID
data "aws_caller_identity" "current_account" {
}