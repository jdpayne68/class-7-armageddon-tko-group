resource "aws_instance" "armageddon_ec201_private_bonus" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.armageddon_private_subnets[0].id
  vpc_security_group_ids = [aws_security_group.armageddon_ec2_sg01.id]
  iam_instance_profile   = aws_iam_instance_profile.armageddon_instance_profile01.name

  tags = {
    Name = "${local.armageddon_prefix}-ec2-private-bonus"
  }
}
