#create asg for sau_paulo region
resource "aws_launch_configuration" "sau_paulo_launch_configuration" {
    provider = aws.sau_paulo
    name_prefix   = "sau_paulo_launch_configuration_"
    image_id      = "ami-0d5d9d301c853a04a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    security_groups = [aws_security_group.sau_paulo_asg_sg.id]
    lifecycle {
        create_before_destroy = true
    }
    }   

# create security group for asg in sau_paulo region
resource "aws_security_group" "sau_paulo_asg_sg" {
    provider = aws.sau_paulo
    name        = "sau_paulo_asg_sg"
    description = "Security group for sau_paulo asg"
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
        Name = "sau_paulo_asg_sg"
    }
}