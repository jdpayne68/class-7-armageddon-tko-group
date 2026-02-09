#create data file for sau_paulo region
data "aws_availability_zones" "sau_paulo_azs" {
    provider = aws.sau_paulo
    state    = "available"
    } 

data "aws_region" "sau_paulo_region" {
    provider = aws.sau_paulo
    }