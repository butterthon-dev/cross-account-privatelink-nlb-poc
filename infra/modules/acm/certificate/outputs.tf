output "arn" {
  description = "証明書のARN"
  value       = aws_acm_certificate.this.arn
}

output "domain_validation_options" {
  description = "DNS検証用レコード情報"
  value = [
    for opt in aws_acm_certificate.this.domain_validation_options : {
      name  = opt.resource_record_name
      type  = opt.resource_record_type
      value = opt.resource_record_value
    }
  ]
}
