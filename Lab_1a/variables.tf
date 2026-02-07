variable "application_name" {
  type    = string
  default = "armageddon-lab-1a"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Input environment name (dev, test, prod)."

  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "Environment must be: dev, test, or prod."
  }
}

variable "region_choice" {
  type        = string
  default     = "1" # Defaults region to us-east-1
  description = <<EOT
Choose an Availability Zone by number:
    1   =   us-east-1
    2   =   us-west-2
    3   =   ca-central-1
    4   =   eu-west-1
    5   =   ap-northeast-1
    6   =   ap-southeast-2
EOT
  validation {
    condition     = contains(["1", "2", "3", "4", "5", "6"], var.region_choice)
    error_message = "AZ choice must be: 1, 2, 3, 4, 5, or 6."
  }
}

variable "region_map" {
  type = map(string)
  default = {
    "1" = "us-east-1"
    "2" = "us-west-2"
    "3" = "ca-central-1"
    "4" = "eu-west-1"
    "5" = "ap-northeast-1"
    "6" = "ap-southeast-2"
  }
}

variable "trusted_ip" {
  type    = string
  default = "0.0.0.0/0" # 0.0.0.0/0 only for temporary testing.
  # For proeuction, enter your private IP CIDR block or manually add Instance Connect Region Prefix in conosole.
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-tutorial.html#eic-tut1-task2
  description = "Enter trusted IPv4 address as CIDR block (/32):"

  validation {
    condition     = can(cidrnetmask(var.trusted_ip))
    error_message = "Must be a valid IPv4 CIDR block address (e.g., 192.168.1.0/24 or 10.0.0.1/32)."
  }
}