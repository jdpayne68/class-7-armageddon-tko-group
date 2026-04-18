# Random string for suffixes
resource "random_string" "suffix" {
  length  = 5
  special = false
}

# Shared random integer resource for deploying resources on a random subnet.
resource "random_integer" "subnet_picker" {
  min = 0
  max = length(local.public_subnets) - 1
}
# Note: This resource is shared. Keep the number of subnets symmetrical so it does't break when using with other subnet types (ex, 3 public, 3 private, 3 data).