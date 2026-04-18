# WAF Web ACL for RDS Application Load Balancer
resource "aws_wafv2_web_acl" "rds_app" {
  name        = "web-acl-rds-app-${local.name_suffix}"
  description = "Common WAF Web ACL for regional resources"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

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
}

# WAF Web ACL Association with RDS Application Load Balancer
resource "aws_wafv2_web_acl_association" "rds_app_waf_alb" {
  resource_arn = aws_lb.rds_app_public_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.rds_app.arn
}