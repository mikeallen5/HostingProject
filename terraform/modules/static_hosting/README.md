# STATIC_HOSTING Module

## Module Purpose
This module deploys a static website with SSL, CDN and WAF support.

## Input Variables
aws_region          -- The AWS region to deploy resources into
website_bucket_name -- Name of the bucket that hosts the static website
domain_name         -- The domain name to use for the website. Configures ACM certificate and DNS for the CloudFront distribution

## Output Variables