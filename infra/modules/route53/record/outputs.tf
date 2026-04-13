output "fqdn" {
  description = "レコードのFQDN"
  value       = aws_route53_record.this.fqdn
}
