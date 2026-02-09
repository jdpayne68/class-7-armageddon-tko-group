# creating a VPC
resource "aws_vpc" "sau_paulo_vpc" {
  provider = aws.sau_paulo
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "sau_paulo_vpc"
    }
}
