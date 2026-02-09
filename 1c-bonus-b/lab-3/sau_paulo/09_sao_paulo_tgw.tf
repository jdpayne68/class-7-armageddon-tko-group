#create transit gateway for sau_paulo region
resource "aws_ec2_transit_gateway" "sau_paulo_tgw" {
    provider = aws.sau_paulo
        description = "sau_paulo_transit_gateway"
        tags = {
            Name = "sau_paulo_tgw"
        }
    }
  
# create transit gateway attachment for sau_paulo VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "sau_paulo_tgw_attachment" {
    provider = aws.sau_paulo
    transit_gateway_id = aws_ec2_transit_gateway.sau_paulo_tgw.id
    vpc_id             = aws_vpc.sau_paulo_vpc.id
    subnet_ids        = [
        aws_subnet.sau_paulo_public_subnet_1.id,
        aws_subnet.sau_paulo_public_subnet_2.id
    ]
        tags = {
            Name = "sau_paulo_tgw_attachment"
        }
    } 
# create transit gateway route table for sau_paulo region 
resource "aws_ec2_transit_gateway_route_table" "sau_paulo_tgw_route_table" {
    provider = aws.sau_paulo
    transit_gateway_id = aws_ec2_transit_gateway.sau_paulo_tgw.id
        tags = {
            Name = "sau_paulo_tgw_route_table"
        }
    }

# associate transit gateway attachment with transit gateway route table
resource "aws_ec2_transit_gateway_route_table_association" "sau_paulo_tgw_route_table_association" {
    provider = aws.sau_paulo
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.sau_paulo_tgw_attachment.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sau_paulo_tgw_route_table.id
    }

# create transit gateway route for sau_paulo region
resource "aws_ec2_transit_gateway_route" "sau_paulo_tgw_route" {
    provider = aws.sau_paulo
    destination_cidr_block         = "10.0.2.0/16"
        transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sau_paulo_tgw_route_table.id
        transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.sau_paulo_tgw_attachment.id
    }

    