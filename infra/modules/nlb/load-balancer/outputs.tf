output "arn" {
  description = "NLBのARN"
  value       = aws_lb.this.arn
}

output "dns_name" {
  description = "NLBのDNS名"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "NLBのHosted Zone ID"
  value       = aws_lb.this.zone_id
}
