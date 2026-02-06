# EC2 - Public App EC2
resource "aws_instance" "public_app" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = local.random_public_subnet
  vpc_security_group_ids = [local.ec2_sg_id]

  iam_instance_profile = aws_iam_instance_profile.get_db_secret.name
  # key_name             = aws_key_pair.tf_armageddon_key.key_name
  # Replace with your key aws_key_pair resource to test EC2 via SSH

  user_data = templatefile(
    "${path.module}/templates/1a_user_data.sh.tpl",
    {
      region    = local.region,
      secret_id = local.secret_id
    }
  )

  associate_public_ip_address = true

  tags = {
    Name        = "public-app-ec2"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Service     = "post-notes"
    Component   = "compute-ec2"
    Scope       = "frontend"
  }
}

# Instance Profile
resource "aws_iam_instance_profile" "get_db_secret" {
  name = "get-db-secret-profile"
  role = aws_iam_role.public_app.name
}

# EC2 Data
# EC2 ENI - Public App EC2
data "aws_network_interface" "public_app_eni" {
  id = aws_instance.public_app.primary_network_interface_id
}