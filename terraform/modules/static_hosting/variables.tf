variable "aws_region" {
  description = "The AWS region to deploy resources into"
}

variable "website_bucket_name" {
  description = "Name of the bucket that hosts the static website"
}

variable "acm_domain_name" {
  description = "The domain name to use for the website"
}

variable "r53_domain_name" {
  description = "The domain name to create r53 dns records in"
}

variable "tags" {
  description = "Tags to apply to all AWS resource created by this module"
}