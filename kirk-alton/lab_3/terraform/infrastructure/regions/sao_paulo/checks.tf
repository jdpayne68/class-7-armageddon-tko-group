# ----------------------------------------------------------------
# SAO PAULO CHECKS — Input Validation Checks
# ----------------------------------------------------------------
# Checks run before resource creation and raise errors when input
# conditions are invalid. Checks should reference only variables
# and locals — never Terraform resources.

# ----------------------------------------------------------------
# VALIDATION — WAF Log Mode
# ----------------------------------------------------------------

# check "waf_log_mode_validation_check" {
#   assert {
#     condition     = local.waf_log_mode_valid
#     error_message = "Only ONE WAF log mode must be active."
#   }
# }