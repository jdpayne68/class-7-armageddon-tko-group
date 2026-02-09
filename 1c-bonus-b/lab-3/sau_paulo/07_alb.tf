#create alb for sau_paulo region
resource "aws_lb" "sau_paulo_alb" { 
    provider = aws.sau_paulo
    name               = "sau-paulo-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sau_paulo_alb_sg.id]
    subnets            = [aws_subnet.sau_paulo_public_subnet_1.id, aws_subnet.sau_paulo_public_subnet_2.id]
        tags = {
            Name = "sau_paulo_alb"
        }
    }

# create security group for alb in sau_paulo region
resource "aws_security_group" "sau_paulo_alb_sg" {
    provider = aws.sau_paulo
    name        = "sau_paulo_alb_sg"
    description = "Security group for sau_paulo alb"
    vpc_id      = aws_vpc.sau_paulo_vpc.id

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
        Name = "sau_paulo_alb_sg"
    }
}