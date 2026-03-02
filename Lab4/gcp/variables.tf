variable "gcp_project_id" {
  type = string
}
variable "gcp_region" {
  type    = string
  default = "us-central1"
}
variable "nihonmachi_vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
variable "nihonmachi_subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}
variable "allowed_vpn_cidrs" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}
variable "tokyo_rds_host" {
  type = string
}
variable "tokyo_rds_port" {
  type    = number
  default = 3306
}
variable "tokyo_rds_user" {
  type    = string
  default = "appuser"
}
variable "db_password_secret_name" {
  type    = string
  default = "nihonmachi-tokyo-rds-password"
}