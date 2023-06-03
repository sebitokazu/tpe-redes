variable "origin_domain_name" {}
variable "bucket_id" {}
variable "certificate_arn" {}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.origin_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/your-cloudfront-access-identity"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 bucket distribution"
  default_root_object = "index.html"

  aliases = [var.bucket_id]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }
}
