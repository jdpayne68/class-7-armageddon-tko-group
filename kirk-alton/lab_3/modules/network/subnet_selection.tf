# ----------------------------------------------------------------
# NETWORKING — Subnet Selection Tools
# ----------------------------------------------------------------

# Shared random integer resource for deploying resources on a random subnet.
resource "random_integer" "subnet_picker" {

  min = 0
  max = length(local.private_app_subnet_ids) - 1
}

# Note: This resource is shared. Keep the number of subnets symmetrical
# so it doesn't break when used with other subnet types
# (e.g., 3 public, 3 private app, 3 private data).