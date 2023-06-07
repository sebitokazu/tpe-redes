provider "aws" {
  region = "us-east-1"

  access_key = "AKIAYFYJBOI7IRFRI4HW"
  secret_key = "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"
  profile                  = "default"

    default_tags {
      tags = {
        author     = "Grupo 3 - 1C2023"
        version    = 1
        university = "ITBA"
        subject    = "Redes"
        created-by = "terraform"
      }
    }
}

module "s3" {
  source = "./modules/s3"
  bucket_name = "infocracks-demo-vsr2"
}

module "cloudfront" {
  source  = "./modules/cloudfront"
  origin_domain_name = module.s3.bucket_regional_domain_name
  certificate_arn = "your_certificate_arn"
  bucket_id = module.s3.bucket_id
}
