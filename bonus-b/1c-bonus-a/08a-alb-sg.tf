############################################
# Security Group: ALB
############################################

# Explanation: The ALB SG is the blast shield — only allow what the Rebellion needs (80/443).
resource "aws_security_group" "armageddon_alb_sg01" {
  name        = "${var.project_name}-alb-sg01"
  description = "ALB security group"
  vpc_id      = aws_vpc.armageddon_vpc01.id

  # TODO: students add inbound 80/443 from 0.0.0.0/0
  # TODO: students set outbound to target group port (usually 80) to private targets

  tags = {
    Name = "${var.project_name}-alb-sg01"
  }
}

# Explanation: armageddon only opens the hangar door — allow ALB -> EC2 on app port (e.g., 80).
resource "aws_security_group_rule" "armageddon_ec2_ingress_from_alb01" {
  type                     = "ingress"
  security_group_id        = aws_security_group.armageddon_ec2_sg01.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.armageddon_alb_sg01.id
  # TODO: students ensure EC2 app listens on this port (or change to 8080, etc.)
}
