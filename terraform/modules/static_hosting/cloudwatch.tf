resource "aws_cloudwatch_dashboard" "main" {
  provider = aws.us-east-1
  dashboard_name = replace(var.acm_domain_name, ".", "-")

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/CloudFront", "Requests", "Region", "Global", "DistributionId", "${aws_cloudfront_distribution.website.id}" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "title": "CloudFront Requests",
                "period": 300,
                "stat": "Sum"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 6,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "title": "CloudFront Error Rate",
                "metrics": [
                    [ "AWS/CloudFront", "TotalErrorRate", "Region", "Global", "DistributionId", "${aws_cloudfront_distribution.website.id}" ]
                ],
                "region": "us-east-1"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/WAFV2", "BlockedRequests", "WebACL", "${aws_wafv2_web_acl.website.name}", "Rule", "ALL", { "color": "#d62728" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "title": "WAF BlockedRequests",
                "period": 300,
                "stat": "Sum"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/WAFV2", "AllowedRequests", "WebACL", "${aws_wafv2_web_acl.website.name}", "Rule", "ALL" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "title": "WAF AllowedRequests",
                "period": 300,
                "stat": "Sum"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 6,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "bar",
                "title": "ACM Certificate Days To Expiry",
                "metrics": [
                    [ "AWS/CertificateManager", "DaysToExpiry", "CertificateArn", "${aws_acm_certificate_validation.website.certificate_arn}" ]
                ],
                "region": "us-east-1",
                "stacked": false,
                "setPeriodToTimeRange": true
            }
        }
    ]
}
  EOF
}

resource "aws_cloudwatch_metric_alarm" "cloudfront_error_rate" {
  provider = aws.us-east-1
  alarm_name                = "${replace(var.acm_domain_name, ".", "-")}-cf-error-rate"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "TotalErrorRate"
  namespace                 = "AWS/CloudFront"
  dimensions = {
    "Region" = "Global",
    "DistributionId" = aws_cloudfront_distribution.website.id
  }

  period                    = "120"
  statistic                 = "Average"
  threshold                 = "25"
  alarm_description         = "This metric monitors CloudFront error rates"
  alarm_actions             = [aws_sns_topic.website.arn]
}

resource "aws_cloudwatch_metric_alarm" "waf_blocked_rate" {
  provider = aws.us-east-1
  alarm_name                = "${replace(var.acm_domain_name, ".", "-")}-waf-blocked-rate"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "BlockedRequests"
  namespace                 = "AWS/WAFV2"
  dimensions = {
    "WebACL" = "${aws_wafv2_web_acl.website.name}",
    "Rule" = "ALL" 
  }

  period                    = "120"
  statistic                 = "Average"
  threshold                 = "25"
  alarm_description         = "This metric monitors WAF blocked request rates"
  alarm_actions             = [aws_sns_topic.website.arn]
}

resource "aws_cloudwatch_metric_alarm" "acm_expiry_days" {
  provider = aws.us-east-1
  alarm_name                = "${replace(var.acm_domain_name, ".", "-")}-acm-expiry-days"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "DaysToExpiry"
  namespace                 = "AWS/CertificateManager"
  dimensions = {
    CertificateArn = aws_acm_certificate_validation.website.certificate_arn
  }

  period                    = "120"
  statistic                 = "Average"
  threshold                 = "25"
  alarm_description         = "This metric monitors days to ACM certificate expiry"
  alarm_actions             = [aws_sns_topic.website.arn]
}