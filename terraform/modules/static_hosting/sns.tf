resource "aws_sns_topic" "website" {
  provider = aws.us-east-1
  name = "${replace(var.acm_domain_name, ".", "-")}-alert-topic"
}