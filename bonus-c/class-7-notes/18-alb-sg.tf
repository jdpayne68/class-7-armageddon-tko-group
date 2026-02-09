

resource "aws_security_group_rule" "armageddon_ec2_ingress_from_alb01" {
  type                     = "ingress"
  security_group_id        = aws_security_group.armageddon_ec2_sg01.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.armageddon_alb_sg01.id
}


