
#Fetch the ACM certificate ARN dynamically based on the domain name
data "aws_acm_certificate" "ssl_cert" {
  domain   = var.root_domain               
  statuses = ["ISSUED"]                    
  most_recent = true                      
}

resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
    name                              = "OAC for S3 Buckets"
    description                       = "Origin Access Control for website bucket"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website_distribution" {
    enabled = true
    is_ipv6_enabled = true 
    default_root_object = var.index_document
    aliases = [var.root_domain]
    
    origin {
        domain_name = "${var.website_bucket}.s3.us-east-1.amazonaws.com"
        origin_id = "S3-${var.website_bucket}"
        origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
    }

    default_cache_behavior {
        allowed_methods = ["GET", "HEAD"]
        cached_methods = ["GET", "HEAD"]
        # Using AWS Managed-CachingOptimized cache policy
        cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        target_origin_id = "S3-${var.website_bucket}"
        viewer_protocol_policy = "redirect-to-https"
    } 

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    # Updated viewer_certificate block to use the fetched SSL cert ARN
    viewer_certificate {
        acm_certificate_arn      = data.aws_acm_certificate.ssl_cert.arn  # Dynamically fetched certificate ARN
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }
}

resource "aws_s3_bucket_policy" "cloudfront_oac_policy" {
  bucket = var.website_bucket

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.website_bucket}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website_distribution.arn
          }
        }
      }
    ]
  })
}

resource "aws_route53_record" "website_alias_record" {
    zone_id = data.aws_route53_zone.dns_zone.zone_id # The hosted zone where the DNS record will be created
    name    = var.root_domain
    type    = "A"

    alias {
        name                   = aws_cloudfront_distribution.website_distribution.domain_name
        zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
        evaluate_target_health = true 
    }
}
