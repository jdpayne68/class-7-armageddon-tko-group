# Check WAF Log Mode Validation
# Checks run before resource creation and give errors when .
# Checks should only reference variables and locals, never resources.
check "waf_log_mode_validation_check" {
  assert {
    condition     = local.waf_log_mode_valid
    error_message = "Only ONE WAF log mode must be active."
  }
}