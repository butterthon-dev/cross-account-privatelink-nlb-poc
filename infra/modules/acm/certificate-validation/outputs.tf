output "certificate_arn" {
  description = "検証済み証明書のARN"
  value       = aws_acm_certificate_validation.this.certificate_arn
}
