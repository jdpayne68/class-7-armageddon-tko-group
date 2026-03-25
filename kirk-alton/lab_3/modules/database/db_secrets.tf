# ----------------------------------------------------------------
# DATABASE — Credential Generation
# ----------------------------------------------------------------

# DB - Lab RDS MySQL Password
resource "random_password" "db_password" {

  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ----------------------------------------------------------------
# SECURITY — Database Credentials (Secrets Manager)
# ----------------------------------------------------------------

# DB Secret - Lab MySQL
resource "aws_secretsmanager_secret" "lab_rds_mysql" {
  provider = aws.regional

  name                    = "lab/rds/mysql-${var.name_suffix}"
  recovery_window_in_days = 0

  tags = merge(
    {
      Name         = "lab-rds-mysql"
      Component    = "security"
      AppComponent = "credentials"
      DataClass    = "confidential"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# SECURITY — Secret Version (Secrets Manager)
# ----------------------------------------------------------------

# DB Secret Contents - Lab MySQl
resource "aws_secretsmanager_secret_version" "lab_rds_mysql" {
  provider = aws.regional

  secret_id = aws_secretsmanager_secret.lab_rds_mysql.id

  secret_string = jsonencode({
    username = local.db_credentials.username
    password = local.db_credentials.password
    host     = aws_db_instance.lab_mysql.address
    port     = local.db_port
  })
}