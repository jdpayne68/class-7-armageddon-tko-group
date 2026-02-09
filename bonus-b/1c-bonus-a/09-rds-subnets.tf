############################################
# RDS Subnet Group
############################################

# Explanation: RDS hides in private subnets like the Rebel base on Hoth—cold, quiet, and not public.
resource "aws_db_subnet_group" "armageddon_rds_subnet_group01" {
  name       = "${local.armageddon_prefix}-rds-subnet-group01"
  subnet_ids = aws_subnet.armageddon_private_subnets[*].id

  tags = {
    Name = "${local.armageddon_prefix}-rds-subnet-group01"
  }
}
