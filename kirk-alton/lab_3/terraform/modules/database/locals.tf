# ----------------------------------------------------------------
# DATABASE — LOCALS
# ----------------------------------------------------------------

locals {

  # ----------------------------------------------------------------
  # SECURITY — Credentials
  # ----------------------------------------------------------------

  # Database credentials
  db_credentials = {
    username = "admin"
    password = random_password.db_password.result # TODO: Update to vault key
  }

  # ----------------------------------------------------------------
  # DATABASE — Engine Mapping
  # ----------------------------------------------------------------

  # DB port map
  db_ports = {
    mysql     = 3306
    postgres  = 5432
    sqlserver = 1433
    oracle    = 1521
  }

  db_port = local.db_ports[lower(var.db_engine)]
}