resource "aws_acm_certificate" "this" {
  provider = aws.cert

  domain_name       = var.cert_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = local.app_id
  }
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.cert

  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validations : record.fqdn]
}

resource "aws_route53_record" "cert_validations" {
  zone_id = data.aws_route53_zone.this.zone_id

  allow_overwrite = true

  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = "300"
}
