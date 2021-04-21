# Create ALIAS record for CloudFront Distribution
resource "aws_route53_record" "website_cloudfront" {
  name            = var.acm_domain_name
  type            = "A"
  zone_id         = data.aws_route53_zone.website.zone_id

  alias {
    name                   = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website.hosted_zone_id}"
    evaluate_target_health = false
  }
}