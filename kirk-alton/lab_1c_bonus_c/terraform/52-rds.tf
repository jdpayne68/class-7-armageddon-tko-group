# DB Helper Resources
resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


# DB - Lab-MySQL
resource "aws_db_instance" "lab_mysql" {
  identifier             = "lab-mysql-${local.name_suffix}"
  db_subnet_group_name   = aws_db_subnet_group.lab_mysql.name
  vpc_security_group_ids = [local.private_db_sg_id]

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 10

  username = local.db_credentials.username
  password = local.db_credentials.password

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "iam-db-auth-error"] # Sends logs to CloudWatch for monitoring. RDS creates and manages the log groups.
  monitoring_interval             = 60
  monitoring_role_arn             = aws_iam_role.rds_enhanced_monitoring_role.arn # Don't forget monitoring role ARN if using a monitring interval other than 0

  parameter_group_name = aws_db_parameter_group.lab_mysql_parameters.name
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