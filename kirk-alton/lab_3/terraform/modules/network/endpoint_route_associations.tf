# ----------------------------------------------------------------
# NETWORKING — VPC Endpoint Route Table Associations
# ----------------------------------------------------------------

# S3 VPC Endpoint Route Table Associations
resource "aws_vpc_endpoint_route_table_association" "s3_private_app_a" {
  provider = aws.regional

  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.local.id
}