variable "aws_region" {
  description = "AWS Region for the Chewbacca fleet to patrol."
  type        = string
  default     = "us-west-2"
}


variable "project_name" {
  description = "Prefix for naming." #Students should change from 'chewbacca' to their own.
  type        = string
  default     = "armageddon-lab-1c"
}

variable "vpc_cidr" {
  description = "VPC CIDR (use 10.x.x.x/xx as instructed)."
  type        = string
  default     = "10.72.0.0/16" # TODO: student supplies
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (use 10.x.x.x/xx)."
  type        = list(string)
  default     = ["10.72.1.0/24", "10.72.2.0/24", "10.72.3.0/24"] # TODO: student supplies
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (use 10.x.x.x/xx)."
  type        = list(string)
  default     = ["10.72.111.0/24", "10.72.112.0/24", "10.72.113.0/24"] # TODO: student supplies
}

variable "azs" {
  description = "Availability Zones list (match count with subnets)."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"] # TODO: student supplies
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 app host."
  type        = string
  default     = "ami-055a9df0c8c9f681c" # TODO
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
  default     = "labrdsdb" # Students can change
}

variable "db_username" {
  description = "DB master username" #(students should use Secrets Manager in 1B/1C).
  type        = string
  default     = "admin" # TODO: student supplies
}

variable "db_password" {
  description = "DB master password" #(DO NOT hardcode in real life; for lab only).
  type        = string
  sensitive   = true
  default     = "Ax2Vmz2lK7" # TODO: student supplies
}

variable "sns_email_endpoint" {
  description = "Email for SNS subscription (PagerDuty simulation)."
  type        = string
  default     = "jacques.payne@gmail.com" # TODO: student supplies
}

variable "trusted_ip"{
  description = "Your trusted IP for SSH access (e.g., my ip)."
  type        = string
  default     = "192.168.1.100/32" # TODO: student supplies
  }
