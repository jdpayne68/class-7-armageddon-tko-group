/* provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.aws_shared_credentials_file
  profile                 = var.aws_profile
}

# Required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.18.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}
 */