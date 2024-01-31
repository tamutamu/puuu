output "aws_acm_certificate" {
  value = aws_acm_certificate.this
}

output "aws_acm_certificate_validation" {
  value = aws_acm_certificate_validation.cert
}
