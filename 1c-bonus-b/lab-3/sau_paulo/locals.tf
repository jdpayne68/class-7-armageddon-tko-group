#create locals for sau_paulo region
locals {
    sau_paulo_region           = "sa-east-1"
    sau_paulo_vpc_cidr        = "10.2.0.0/16"
    sau_paulo_public_subnet_1_cidr  = "10.2.1.0/24"
    sau_paulo_public_subnet_2_cidr  = "10.2.2.0/24"
    sau_paulo_private_subnet_1_cidr = "10.2.3.0/24"
    sau_paulo_private_subnet_2_cidr = "10.2.4.0/24"
}

