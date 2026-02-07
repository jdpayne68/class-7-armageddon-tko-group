# DB Secret
resource "aws_secretsmanager_secret" "lab_rds_mysql" {
  name                    = "lab/rds/mysql-${local.name_suffix}"
  recovery_window_in_days = 0

  tags = {
    Name         = "lab-rds-mysql"
    Component    = "security"
    AppComponent = "credentials"
    DataClass    = "confidential"
  }
}

# DB Secret Contents
resource "aws_secretsmanager_secret_version" "lab_rds_mysql" {
  secret_id = aws_secretsmanager_secret.lab_rds_mysql.id
  secret_string = jsonencode({
    username = local.db_credentials.username
    password = local.db_credentials.password
    host     = aws_db_instance.lab_mysql.address
    port     = 3306
  })
}