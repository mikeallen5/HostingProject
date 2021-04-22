output "cloudfront_url" {
 description = "The URL of the CloudFront distribution"
 value       = module.static_hosting.cloudfront_url
}

output "cloudfront_cnames" {
 description = "The CNAMES of the CloudFront distribution"
 value       = module.static_hosting.cloudfront_cnames
}