# ----------------------------------------------------------------
# WAF Web ACL for CloudFront (Edge Protection)
# ----------------------------------------------------------------
resource "aws_wafv2_web_acl" "rds_app" {
  provider = aws.regional

  count = var.create_waf ? 1 : 0

  name        = "web-acl-rds-app-${var.name_suffix}"
  description = "WAF Web ACL for CloudFront resources"
  scope       = "CLOUDFRONT"


  default_action {
    allow {}
  }

  # Core WAF Rules
  rule {
    name     = "CommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "common-rule-set"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AdminProtectionRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "admin-protection-rule-set"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "KnownBadInputsRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "known-bad-inputs-rule-set"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-rds-app"
    sampled_requests_enabled   = true
  }

  tags = merge(
    {
      Name      = "waf-rds-app"
      Component = "security-edge"
      Scope     = "cloudfront"
      DataClass = "confidential"
    },
    var.context.tags
  )
}

# CloudFront WAF association is done directly in the distribution. No need for a separate resource