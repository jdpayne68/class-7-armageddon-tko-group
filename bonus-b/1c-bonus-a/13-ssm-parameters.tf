############################################
# Parameter Store (SSM Parameters)
############################################

# Explanation: Parameter Store is armageddon’s map—endpoints and config live here for fast recovery.
resource "aws_ssm_parameter" "armageddon_db_endpoint_param" {
  name  = "/lab/db/endpoint"
  type  = "String"
  value = aws_db_instance.lab-mysql.address

  tags = {
    Name = "${local.armageddon_prefix}-param-db-endpoint"
  }
}

# Explanation: Ports are boring, but even Wookiees need to know which door number to kick in.
resource "aws_ssm_parameter" "armageddon_db_port_param" {
  name  = "/lab/db/port"
  type  = "String"
  value = tostring(aws_db_instance.lab-mysql.port)

  tags = {
    Name = "${local.armageddon_prefix}-param-db-port"
  }
}

# Explanation: DB name is the label on the crate—without it, you’re rummaging in the dark.
resource "aws_ssm_parameter" "armageddon_db_name_param" {
  name  = "/lab/db/name"
  type  = "String"
  value = var.db_name

  tags = {
    Name = "${local.armageddon_prefix}-param-db-name"
  }
}
