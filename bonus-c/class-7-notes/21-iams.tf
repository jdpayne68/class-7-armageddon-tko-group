############################################
# IAM Role + Instance Profile for EC2
############################################

resource "aws_iam_role" "armageddon_ec2_role01" {
  name = "${local.name_prefix}-ec2-role01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "armageddon_ec2_ssm_attach" {
  role       = aws_iam_role.armageddon_ec2_role01.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "armageddon_ec2_secrets_attach" {
  role       = aws_iam_role.armageddon_ec2_role01.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite" # TODO: student replaces w/ least privilege
}

resource "aws_iam_role_policy_attachment" "armageddon_ec2_cw_attach" {
  role       = aws_iam_role.armageddon_ec2_role01.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "armageddon_instance_profile01" {
  name = "${local.name_prefix}-instance-profile01"
  role = aws_iam_role.armageddon_ec2_role01.name
}
