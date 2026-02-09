#create routes in sau_paulo region to route traffic via transit gateway
resource "aws_route" "sau_paulo_tgw_route_to_10_1_0_0_16" {
    provider = aws.sau_paulo
    route_table_id         = aws_route_table.sau_paulo_private_route_table.id
    destination_cidr_block = "10.1.0.0/16"
        transit_gateway_id     = aws_ec2_transit_gateway.sau_paulo_tgw.id      
    }
resource "aws_route" "sau_paulo_tgw_route_to_10_2_0_0_16" {
    provider = aws.sau_paulo
    route_table_id         = aws_route_table.sau_paulo_private_route_table.id
    destination_cidr_block = "10.2.0.0/16"
        transit_gateway_id     = aws_ec2_transit_gateway.sau_paulo_tgw.id      
    }

#create routes in sau_paulo region to route traffic via transit gateway
resource "aws_ec2_transit_gateway_route" "sau_paulo_tgw_route_to_10_0_0_0_16" {
    provider = aws.sau_paulo
    destination_cidr_block         = "10.0.0.0/16"
        transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sau_paulo_tgw_route_table.id
        transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.sau_paulo_tgw_attachment.id
    }


    