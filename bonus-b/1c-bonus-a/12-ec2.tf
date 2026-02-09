############################################
# EC2 Instance (App Host)
############################################

# Explanation: This is your “Han Solo box”—it talks to RDS and complains loudly when the DB is down.
resource "aws_instance" "armageddon_ec201" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.armageddon_public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.lab-ec2-app.id]
  iam_instance_profile   = aws_iam_instance_profile.armageddon_instance_profile01.name

  # TODO: student supplies user_data to install app + CW agent + configure log shipping
  # user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "${local.armageddon_prefix}-ec201"
  }
}

############################################
# Move EC2 into PRIVATE subnet (no public IP)
############################################

# Explanation: armageddon hates exposure—private subnets keep your compute off the public holonet.
resource "aws_instance" "armageddon_ec201_private_bonus" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.armageddon_private_subnets[0].id
  vpc_security_group_ids = [aws_security_group.lab-ec2-app.id]
  iam_instance_profile   = aws_iam_instance_profile.armageddon_instance_profile01.name

  # TODO: Students should remove/disable SSH inbound rules entirely and rely on SSM.
  # TODO: Students add user_data that installs app + CW agent; for true hard mode use a baked AMI.

  tags = {
    Name = "${local.armageddon_prefix}-ec201-private"
  }
}
