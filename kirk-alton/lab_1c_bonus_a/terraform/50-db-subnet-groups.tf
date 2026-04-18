resource "aws_db_subnet_group" "lab_mysql" {
  name       = "lab-mysql-subnet-group"
  subnet_ids = local.private_data_subnets

  tags = merge(
    {
      Name = "labmysql-db-subnet-group"
      #Scope = aws_db_instance.lab_mysql.name
    },
    local.private_subnet_tags
  )
}