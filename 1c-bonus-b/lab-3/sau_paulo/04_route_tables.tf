#create a route table for sau_paulo region
resource "aws_route_table" "sau_paulo_public_route_table" {
    provider = aws.sau_paulo
    vpc_id   = aws_vpc.sau_paulo_vpc.id
        tags = {
            Name = "sau_paulo_public_route_table"
        }
    }   

# create route to internet gateway for public route table
resource "aws_route" "sau_paulo_public_internet_route" {
    provider = aws.sau_paulo
    route_table_id         = aws_route_table.sau_paulo_public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
        gateway_id             = aws_internet_gateway.sau_paulo_internet_gateway.id      
    }   


# associate public subnets with public route table
resource "aws_route_table_association" "sau_paulo_public_subnet_1_association" {
    provider = aws.sau_paulo
    subnet_id      = aws_subnet.sau_paulo_public_subnet_1.id
    route_table_id = aws_route_table.sau_paulo_public_route_table.id
    }

resource "aws_route_table_association" "sau_paulo_public_subnet_2_association" {
    provider = aws.sau_paulo
    subnet_id      = aws_subnet.sau_paulo_public_subnet_2.id
    route_table_id = aws_route_table.sau_paulo_public_route_table.id
    }

##########################private route table for sau_paulo region##########################
#create private route table for sau_paulo region
resource "aws_route_table" "sau_paulo_private_route_table" {
    provider = aws.sau_paulo
    vpc_id   = aws_vpc.sau_paulo_vpc.id
        tags = {
            Name = "sau_paulo_private_route_table"
        }
    }   

# create route to nat gateway for private route table
resource "aws_route" "sau_paulo_private_nat_route" {
    provider = aws.sau_paulo
    route_table_id         = aws_route_table.sau_paulo_private_route_table.id
    destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = aws_nat_gateway.sau_paulo_nat_gateway.id      
    }
# associate private subnets with private route table
resource "aws_route_table_association" "sau_paulo_private_subnet_1_association" {
    provider = aws.sau_paulo
    subnet_id      = aws_subnet.sau_paulo_private_subnet_1.id
    route_table_id = aws_route_table.sau_paulo_private_route_table.id
    }   
resource "aws_route_table_association" "sau_paulo_private_subnet_2_association" {
    provider = aws.sau_paulo
    subnet_id      = aws_subnet.sau_paulo_private_subnet_2.id
    route_table_id = aws_route_table.sau_paulo_private_route_table.id
    }

# you must have nat gateway to create route to internet in private subnet, so we need to create eip for nat gateway
resource "aws_eip" "sau_paulo_nat_eip" {
    provider = aws.sau_paulo        
#   vpc      = true
        tags = {
            Name = "sau_paulo_nat_eip"
        }
    }

