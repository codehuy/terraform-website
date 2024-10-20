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