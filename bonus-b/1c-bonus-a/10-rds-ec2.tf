############################################
# RDS Instance (MySQL)
############################################

# Explanation: This is the holocron of state—your relational data lives here, not on the EC2.
resource "aws_db_instance" "lab-mysql" {
  identifier        = "${local.armageddon_prefix}-rds01"
  engine            = var.db_engine
  instance_class    = var.db_instance_class
  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.armageddon_rds_subnet_group01.name
  vpc_security_group_ids = [aws_security_group.armageddon_rds_sg01.id]

  publicly_accessible = false
  skip_final_snapshot = true

  # TODO: student sets multi_az / backups / monitoring as stretch goals

  tags = {
    Name = "${local.armageddon_prefix}-rds01"
  }
}
