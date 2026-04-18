# ----------------------------------------------------------------
# DATABASE — RDS Instances (MySQL)
# ----------------------------------------------------------------

# DB - Lab-MySQL
resource "aws_db_instance" "lab_mysql" {
  provider = aws.regional

  identifier             = "lab-mysql-${var.name_suffix}"
  db_subnet_group_name   = aws_db_subnet_group.lab_mysql.name
  vpc_security_group_ids = [var.private_db_sg_id]

  engine            = var.db_engine
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 10

  username = local.db_credentials.username
  password = local.db_credentials.password

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "iam-db-auth-error"]
  monitoring_interval             = 60
  monitoring_role_arn             = var.rds_enhanced_monitoring_role_arn

  parameter_group_name = aws_db_parameter_group.lab_mysql_parameters.name
  skip_final_snapshot  = true

  tags = merge(
    {
      Name        = "lab-mysql"
      App         = "${var.context.app}"
      Environment = "${var.context.env}"
      Service     = "post-notes"
      Component   = "data-db"
      Scope       = "backend"
      Engine      = var.db_engine
      DataClass   = "confidential"
    },
    var.private_data_subnet_tags,
    var.context.tags
  )
}