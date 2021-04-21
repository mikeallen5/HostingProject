# Cloudfront OAI, for restricting access to the S3 bucket to only allow access from CloudFront 
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for static website"
}

# CloudFront for SSL, CDN and WAF
resource "aws_cloudfront_distribution" "website" {
  aliases =  [var.acm_domain_name]

  // origin is where CloudFront gets it's content from
  origin {
    s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }    
    // Here we're using our S3 bucket's URL
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
  
    // This can be any name to identify this origin
    origin_id = var.website_bucket_name

  }

  web_acl_id = aws_wafv2_web_acl.website.arn
  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    // This needs to match the 'origin_id' above
    target_origin_id = var.website_bucket_name
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    forwarded_values {
      query_string = false
      cookies {
          forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
        restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.website.certificate_arn
    ssl_support_method = "sni-only"
  }
}
