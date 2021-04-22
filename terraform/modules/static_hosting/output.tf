output "cloudfront_url" {
  description = "The URL of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_cnames" {
  description = "The CNAMES of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.aliases
}