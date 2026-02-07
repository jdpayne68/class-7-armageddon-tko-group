# Random string for suffixes
resource "random_string" "suffix" {
  length  = 5
  special = false
}

locals {
  public_subnet_count = 3
}

resource "random_integer" "subnet_picker" {
  min = 0
  max = local.public_subnet_count - 1
}
# Note: This resource is shared. Keep the number of subnets symmetrical so it does't break when using with other subnet types (ex, 3 public, 3 private, 3 data).


