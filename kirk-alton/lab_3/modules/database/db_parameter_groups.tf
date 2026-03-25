# ----------------------------------------------------------------
# DATABASE — Parameter Groups (MySQL 8.0)
# ----------------------------------------------------------------

# Custom Parameter Groups - LabMySQL DB
resource "aws_db_parameter_group" "lab_mysql_parameters" {
  provider = aws.regional

  name   = "${var.name_prefix}-lab-mysql-parameters-${var.context.env}"
  family = "mysql8.0"

  parameter {
    name  = "log_output"
    value = "FILE" # Valid values for MySQL are: TABLE (on db), FILE (log file), NONE
  }

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "log_error_verbosity"
    value = "3" # Value 3 outputs ERROR, WARNING and INFORMATION to error logs
  }

  tags = merge(
    {
      Name        = "lab-mysql-parameters"
      App         = "${var.context.app}"
      Environment = "${var.context.env}"
      Component   = "db-parameters"
      Scope       = "logging"
      Engine      = var.db_engine
      DataClass   = "confidential"
    },
    var.context.tags
  )
}