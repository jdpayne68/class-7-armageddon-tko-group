# DB Helper Resources
resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# DB - Lab-MyySQL
resource "aws_db_instance" "lab_mysql" {
  identifier             = "lab-mysql-${local.name_suffix}"
  db_subnet_group_name   = aws_db_subnet_group.armageddon_1a_db.name
  vpc_security_group_ids = [local.private_db_sg_id]

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 10

  username = local.db_credentials.username
  password = local.db_credentials.password

  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  tags = {
    Name        = "lab-mysql"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Service     = "post-notes"
    Component   = "data-db"
    Scope       = "backend"
    Engine      = "mysql"
    DataClass   = "confidential"
  }
}

