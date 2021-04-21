# Configure an AWS WAF ruleset that uses AWS Managed rules to mitigate against common OWASP Top 10 Vulnerabilities:
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
resource "aws_wafv2_web_acl" "website" {
  provider = aws.us-east-1
  name        = "aws-managed-rules"
  description = "AWS Managed Rules"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}