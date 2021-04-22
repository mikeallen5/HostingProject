terraform {
  backend "s3" {
    bucket = "automation-project-terraform-state"
    key    = "static_hosting/terraform.tfstate"
    region = "eu-west-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.37.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
}

module "static_hosting" {
  source = "../../modules/static_hosting"

  aws_region          = "eu-west-1"
  website_bucket_name = "static-hosting-project-website"
  acm_domain_name     = "staticwebsite.permacrypt.com"
  r53_domain_name     = "permacrypt.com"

  tags = {
    BUILT_BY    = "TERRAFORM"
    ENVIRONMENT = "DEVELOPMENT"
    OWNER       = "MICHAEL"
  }

}