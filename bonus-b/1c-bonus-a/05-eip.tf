############################################
# EIP
############################################

# Explanation: armageddon wants the private base to call home—EIP gives the NAT a stable “holonet address.”
resource "aws_eip" "armageddon_nat_eip01" {
  domain = "vpc"

  tags = {
    Name = "${local.armageddon_prefix}-nat-eip01"
  }
}
