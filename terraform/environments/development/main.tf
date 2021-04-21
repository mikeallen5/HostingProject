terraform {
  backend "s3" {
    bucket = "automation-project-terraform-state"
    key    = "static_hosting/terraform.tfstate"
    region = "eu-west-1"
  }
}
 
provider "aws" {
  version = "3.37.0"
  region  = "eu-west-1"
}

module "static_hosting" {
  source = "../../modules/static_hosting"

  aws_region = "eu-west-1"

  website_bucket_name = "static-hosting-project-website"

  acm_domain_name = "staticwebsite.permacrypt.com"

  r53_domain_name = "permacrypt.com"

}