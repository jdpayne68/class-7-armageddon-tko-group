# Checks run before resource creation and give errors when input conditions are invalid.
# Checks should only reference variables and locals, never resources.

# ----------------------------------------------------------------
# VALIDATION CHECKS — WAF Log Mode
# ----------------------------------------------------------------

# Check WAF Log Mode Validation
check "waf_log_mode_validation_check" {
  assert {
    condition     = local.waf_log_mode_valid
    error_message = "Only ONE WAF log mode must be active."
  }
}
