#create security group for sau_paulo region
resource "aws_security_group" "sau_paulo_sg" {
    provider = aws.sau_paulo
    name        = "sau_paulo_sg"
    description = "Security group for sau_paulo region"
    vpc_id      = aws_vpc.sau_paulo_vpc.id

    # allow inbound SSH traffic
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # allow inbound HTTP traffic
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sau_paulo_sg"
    }   

}