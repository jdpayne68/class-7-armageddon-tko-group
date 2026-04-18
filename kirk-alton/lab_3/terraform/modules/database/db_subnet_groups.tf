# ----------------------------------------------------------------
# DATABASE — Subnet Groups (Private Data Tier)
# ----------------------------------------------------------------

resource "aws_db_subnet_group" "lab_mysql" {
  provider = aws.regional

  name       = "lab-mysql-subnet-group"
  subnet_ids = var.private_data_subnet_ids

  tags = merge(
    {
      Name = "labmysql-db-subnet-group"
    },
    var.private_data_subnet_tags,
    var.context.tags
  )
}