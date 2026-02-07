# SSM Parameter Store - Username for LabMySQL DB
resource "aws_ssm_parameter" "lab_mysql_db_username" {
  name  = "/lab/rds/mysql/db-username-${local.name_suffix}"
  type  = "String"
  value = local.db_credentials.username

  tags = {
    Name         = "lab-rds-mysql-username"
    Component    = "security"
    AppComponent = "login-parameters"
    DataClass    = "internal"
  }
}

# SSM Parameter Store - Database Name for LabMySQL DB
resource "aws_ssm_parameter" "lab_mysql_db_name" {
  name  = "/lab/rds/mysql/db-name-${local.name_suffix}"
  type  = "String"
  value = aws_db_instance.lab_mysql.identifier

  tags = {
    Name         = "lab-rds-mysql-db-name"
    Component    = "security"
    AppComponent = "login-parameters"
    DataClass    = "internal"
  }
}



# SSM Parameter Store - Host Address for LabMySQL DB #Host = Endpoint
resource "aws_ssm_parameter" "lab_mysql_db_host" {
  name  = "/lab/rds/mysql/host-${local.name_suffix}"
  type  = "String"
  value = aws_db_instance.lab_mysql.address

  tags = {
    Name         = "lab-rds-mysql-db-host"
    Component    = "security"
    AppComponent = "login-parameters"
    DataClass    = "internal"
  }
}

# SSM Parameter Store - DB Port for LabMySQL DB
resource "aws_ssm_parameter" "lab_mysql_db_port" {
  name  = "/lab/rds/mysql/port-${local.name_suffix}"
  type  = "String"
  value = tostring(aws_db_instance.lab_mysql.port)

  tags = {
    Name         = "lab-rds-mysql-db-port"
    Component    = "security"
    AppComponent = "login-parameters"
    DataClass    = "internal"
  }
}
