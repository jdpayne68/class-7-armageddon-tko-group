# WAF Web ACL for RDS ALB
resource "aws_wafv2_web_acl" "rds_app" {
  name        = "web-acl-rds-app-${local.name_suffix}"
  description = "Common WAF Web ACL for regional resources"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # # Temporary Rule for Testing WAF
  # # /add on url is blocked. Should create a loggable record to test log delivery to S3
  # rule {
  #   name     = "ForceWafLogValidation"
  #   priority = 0

  #   action {
  #     block {}
  #   }

  #   statement {
  #     byte_match_statement {
  #       search_string = "/add"
  #       field_to_match {
  #         uri_path {}
  #       }
  #       positional_constraint = "CONTAINS"

  #       text_transformation {
  #         priority = 0
  #         type     = "NONE"
  #       }
  #     }
  #   }

  #   visibility_config {
  #     sampled_requests_enabled   = true
  #     cloudwatch_metrics_enabled = true
  #     metric_name                = "force-waf-log"
  #   }
  # }


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

  tags = {
    Name        = "waf-rds-app"
    App         = "${local.app}"
    Environment = "${local.env}"
    Component   = "security-edge"
    Scope       = "regional"
    DataClass   = "confidential"
  }
}

# WAF Web ACL Association with RDS ALB
resource "aws_wafv2_web_acl_association" "rds_app_waf_alb" {
  resource_arn = aws_lb.rds_app_public_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.rds_app.arn
}