############################################
# Secrets Manager (DB Credentials)
############################################

# Explanation: Secrets Manager is armageddon’s locked holster—credentials go here, not in code.
resource "aws_secretsmanager_secret" "lab_rds_mysql" {
  name                           = "lab/rds/mysql"
  recovery_window_in_days        = 7
  force_overwrite_replica_secret = true
}

# Explanation: Secret payload—students should align this structure with their app (and support rotation later).
resource "aws_secretsmanager_secret_version" "lab_rds_mysql" {
  secret_id = aws_secretsmanager_secret.lab_rds_mysql.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = aws_db_instance.lab-mysql.address
    port     = aws_db_instance.lab-mysql.port
    dbname   = var.db_name
  })
}
