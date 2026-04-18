# ----------------------------------------------------------------
# SAO PAULO AZ VALIDATION — Availability Zone Validation
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# DATA — Availability Zones
# ----------------------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

# ----------------------------------------------------------------
# VALIDATION — Availability Zone Count
# ----------------------------------------------------------------

resource "null_resource" "validate_az_count" {

  lifecycle {
    precondition {
      condition     = length(data.aws_availability_zones.available.names) >= 3
      error_message = "This deployment requires a region with at least 3 Availability Zones. Please select a different region."
    }
  }

}