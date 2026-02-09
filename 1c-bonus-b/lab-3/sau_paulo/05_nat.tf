#create nat gateway for sau_paulo region
resource "aws_eip" "sau_paulo_nat_eip" {
    provider = aws.sau_paulo
    
        tags = {
            Name = "sau_paulo_nat_eip"
        }
    }   

resource "aws_nat_gateway" "sau_paulo_nat_gateway" {
    provider = aws.sau_paulo
    allocation_id = aws_eip.sau_paulo_nat_eip.id
    subnet_id     = aws_subnet.sau_paulo_public_subnet_1.id
        tags = {
            Name = "sau_paulo_nat_gateway"
        }
    }   


