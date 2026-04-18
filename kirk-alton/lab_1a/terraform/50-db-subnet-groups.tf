resource "aws_db_subnet_group" "armageddon_1a_db" {
  name       = "armageddon-1a-db-subnet-group"
  subnet_ids = local.private_data_subnets

  tags = {
    Name = "armageddon-1a-db-subnet-group"
  }
}