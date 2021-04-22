resource "aws_acm_certificate" "website" {
  provider = aws.us-east-1
  domain_name       =  var.acm_domain_name
  validation_method = "DNS"
  tags = var.tags
}
 
data "aws_route53_zone" "website" {
  name         = var.r53_domain_name
  private_zone = false
}

# Create R53 records to validate the ACM Certificate
resource "aws_route53_record" "website" {
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.website.zone_id
}

# Wait for the ACM Certificate to be created before using it in CloudFront
resource "aws_acm_certificate_validation" "website" {
  provider = aws.us-east-1
  certificate_arn         = aws_acm_certificate.website.arn
  validation_record_fqdns = [for record in aws_route53_record.website : record.fqdn]
}
