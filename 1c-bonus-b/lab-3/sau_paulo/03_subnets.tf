#create subnets for sau_paulo region
resource "aws_subnet" "sau_paulo_public_subnet_1" {
  provider = aws.sau_paulo
  vpc_id            = aws_vpc.sau_paulo_vpc.id
  cidr_block       = "10.0.1.0/24"
    availability_zone = "sa-east-1a"
        tags = {
            Name = "sau_paulo_public_subnet_1"
        }
}

resource "aws_subnet" "sau_paulo_public_subnet_2" {
  provider = aws.sau_paulo
  vpc_id            = aws_vpc.sau_paulo_vpc.id
  cidr_block       = "10.0.2.0/24"
    availability_zone = "sa-east-1b"
        tags = {
            Name = "sau_paulo_public_subnet_2"
        }
}

resource "aws_subnet" "sau_paulo_private_subnet_1" {
  provider = aws.sau_paulo
  vpc_id            = aws_vpc.sau_paulo_vpc.id
  cidr_block       = "10.0.13.0/24"
    availability_zone = "sa-east-1a"
        tags = {
            Name = "sau_paulo_private_subnet_1"
        }           

}
resource "aws_subnet" "sau_paulo_private_subnet_2" {
  provider = aws.sau_paulo
  vpc_id            = aws_vpc.sau_paulo_vpc.id
  cidr_block       = "10.0.14.0/24"
    availability_zone = "sa-east-1b"
        tags = {
            Name = "sau_paulo_private_subnet_2"
        }   
}