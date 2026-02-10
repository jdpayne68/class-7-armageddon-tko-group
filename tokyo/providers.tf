# ============================================
# Lab 3 - TOKYO Providers
# ============================================

# Default provider - Tokyo
provider "aws" {
  region = "ap-northeast-1"
}

# Required for CloudFront WAF (must be us-east-1)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}