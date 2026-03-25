# ----------------------------------------------------------------
# DATABASE — Connection Parameters (SSM Parameter Store)
# ----------------------------------------------------------------

# SSM Parameter Store - DB Name for LabMySQL DB
resource "aws_ssm_parameter" "lab_mysql_db_name" {
  provider = aws.regional

  name  = "/lab/rds/mysql/db-name-${var.name_suffix}"
  type  = "String"
  value = aws_db_instance.lab_mysql.identifier

  tags = merge(
    {
      Name         = "lab-rds-mysql-db-name"
      Component    = "security"
      AppComponent = "login-parameters"
      DataClass    = "internal"
    },
    var.context.tags
  )
}

# SSM Parameter Store - Username for LabMySQL DB
resource "aws_ssm_parameter" "lab_mysql_db_username" {
  provider = aws.regional

  name  = "/lab/rds/mysql/db-username-${var.name_suffix}"
  type  = "String"
  value = local.db_credentials.username

  tags = merge(
    {
      Name         = "lab-rds-mysql-db-username"
      Component    = "security"
      AppComponent = "login-parameters"
      DataClass    = "internal"
    },
    var.context.tags
  )
}

# SSM Parameter Store - Host Address for LabMySQL DB
resource "aws_ssm_parameter" "lab_mysql_db_host" {
  provider = aws.regional

  name  = "/lab/rds/mysql/db-host-${var.name_suffix}"
  type  = "String"
  value = aws_db_instance.lab_mysql.address

  tags = merge(
    {
      Name         = "lab-rds-mysql-db-host"
      Component    = "security"
      AppComponent = "login-parameters"
      DataClass    = "internal"
    },
    var.context.tags
  )
}

# SSM Parameter Store - DB Port for LabMySQL DB
resource "aws_ssm_parameter" "lab_mysql_db_port" {
  provider = aws.regional

  name  = "/lab/rds/mysql/db-port-${var.name_suffix}"
  type  = "String"
  value = tostring(aws_db_instance.lab_mysql.port)

  tags = merge(
    {
      Name         = "lab-rds-mysql-db-port"
      Component    = "security"
      AppComponent = "login-parameters"
      DataClass    = "internal"
    },
    var.context.tags
  )
}