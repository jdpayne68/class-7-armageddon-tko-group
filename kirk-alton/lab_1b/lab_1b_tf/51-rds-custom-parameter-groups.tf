# Custom Parameter Groups - LabMySQL DB
resource "aws_db_parameter_group" "lab_mysql_parameters" {
  name   = "lab-mysql-parameters"
  family = "mysql8.0"

  parameter {
    name  = "log_output"
    value = "FILE" # Valid values for MySQL are: TABLE (on db), FILE (log file), NONE
  }

  parameter {
    name  = "general_log"
    value = "1" # 1 = ON
  }

  parameter {
    name  = "log_error_verbosity"
    value = "3" # Value 3 outputs ERROR, WARNING and INFORMATION to error logs
  }

  tags = {
    Name        = "lab-mysql-parameters"
    App         = "${local.application}"
    Environment = "${local.environment}"
    Component   = "db-parameters"
    Scope       = "logging"
    Engine      = "mysql"
    DataClass   = "confidential"
  }
}