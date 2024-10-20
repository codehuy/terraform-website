# Get the existing route53 hosted zone for root domain
data "aws_route53_zone" "dns_zone" {
  name         = var.root_domain
  private_zone = false
}

# Request an ACM certificate for the root domain and optionally any subdomain
resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.root_domain
  subject_alternative_names = ["*.${var.root_domain}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Create a DNS record in Route 53 to validate the ACM certificate
resource "aws_route53_record" "dns_validation" {
  allow_overwrite = true
  name    = aws_acm_certificate.certificate.domain_validation_options[0].resource_record_name
  records = [aws_acm_certificate.certificate.domain_validation_options[0].resource_record_value]
  type    = aws_acm_certificate.certificate.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  ttl     = 300
}

# Validate the ACM certificate using the DNS record created
resource "aws_acm_certificate_validation" "ssl_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [aws_route53_record.dns_validation.fqdn]
}