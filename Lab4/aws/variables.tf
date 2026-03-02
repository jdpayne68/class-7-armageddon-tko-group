variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "tgw_id" {
  type    = string
  default = "tgw-0c2bb4583fe0d21f4"
}

variable "gcp_bgp_asn" {
  type    = number
  default = 65000
}

variable "tokyo_vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "gcp_vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
