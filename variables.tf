variable "aws_region" {
  description = "AWS Region for the abebe fleet to patrol."
  type        = string
  default     = "eu-west-1"
}

variable "aws_shared_credentials_file" {
  description = "Path to AWS shared credentials file (e.g., ~/.aws/credentials)."
  type        = string
  default     = "~/.aws/credentials"
}

variable "aws_profile" {
  description = "AWS CLI profile name to use for credentials (e.g., 'default')."
  type        = string
  default     = "default"
}

variable "project_name" {
  description = "Prefix for naming. Students should change from 'abebe' to their own."
  type        = string
  default     = "abebe"
}

variable "vpc_cidr" {
  description = "VPC CIDR (use 10.x.x.x/xx as instructed)."
  type        = string
  default     = "10.30.0.0/16" # TODO: student supplies
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (use 10.x.x.x/xx)."
  type        = list(string)
  default     = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"] # TODO: student supplies
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (use 10.x.x.x/xx)."
  type        = list(string)
  default     = ["10.30.101.0/24", "10.30.102.0/24", "10.30.103.0/24"] # TODO: student supplies
}

variable "azs" {
  description = "Availability Zones list (match count with subnets)."
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"] # TODO: student supplies
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 app host."
  type        = string
  default     = "ami-03e091ef64f3907f8" # TODO
}

variable "ec2_instance_type" {
  description = "EC2 instance size for the app."
  type        = string
  default     = "t3.micro"
}

variable "db_engine" {
  description = "RDS engine."
  type        = string
  default     = "mysql"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "abebe_db" # Students can change
}

variable "db_username" {
  description = "DB master username (students should use Secrets Manager in 1B/1C)."
  type        = string
  default     = "admin" # TODO: student supplies
}

variable "db_password" {
  description = "DB master password (DO NOT hardcode in real life; for lab only)."
  type        = string
  sensitive   = true
  default     = "widemouth1$" # TODO: student supplies; in real life put this in the .env file and make sure it's locked down
}

variable "db_instance_identifier" {
  description = "RDS instance identifier."
  type        = string
  default     = "lab-mysql" # Students can change
}

variable "sns_email_endpoint" {
  description = "Email for SNS subscription (PagerDuty simulation)."
  type        = string
  default     = "jobs.cbailly@gmail.com" # TODO: student supplies
}

variable "ip_address" {
  description = "Your current public IP address for SSH access (CIDR format, e.g., 123.45.67.89/32)."
  type        = string
  default     = "192.168.0.199/32" # TODO: supply in real life put this in the .env file and make sure it's locked down
}

variable "secret_id" {
  description = "Secrets Manager secret ID for RDS credentials"
  type        = string
  default     = "lab/rds/mysql"
}