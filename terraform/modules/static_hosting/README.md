# STATIC_HOSTING Module

## Module Purpose
This module deploys a static website with SSL, CDN, WAF and monitoring/alerting support.

## Input Variables
aws_region          -- The AWS region to deploy resources into
website_bucket_name -- Name of the bucket that hosts the static website
acm_domain_name     -- The domain name to use for the ACM Certificate. Configures ACM certificate and DNS for the CloudFront distribution
r53_domain_name     -- The R53 Hosted Zone's Domain Name to creae the A record for the CloudFront distribution
tags                -- Tags to apply to all taggable AWS Resources

## Output Variables
cloudfront_url      -- The URL of the CloudFront distribution
cloudfront_cnames   -- The configured CNAMES/Aliases of the CloudFront distribution