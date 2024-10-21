output "iam_user_arn" {
    description = "IAM User ARN"
    value = aws_iam_user.terraform_user.arn
}

output "ssl_cert_arn" {
    description = "The ARN of the SSL Certificate"
    value = aws_acm_certificate.ssl_certificate.arn
}

output "route53_zone_id" {
    description = "The ID of the Route 53 Zone"
    value = data.aws_route53_zone.dns_zone.zone_id
}

output "bucket_regional_domain_name" {
    description = "The regional domain name of the S3 bucket"
    value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}

output "s3_bucket_id" {
    description = "the ID of the S3 Bucket"
    value = aws_s3_bucket.website_bucket.id
}

output "s3_bucket_arn" {
    description = "the ARN of the S3 Bucket"
    value = aws_s3_bucket.website_bucket.arn
}

output "cloudfront_distribution_id" {
    description = "The ID of the cloudfront distribution"
    value = aws_cloudfront_distribution.website_distribution.id
}