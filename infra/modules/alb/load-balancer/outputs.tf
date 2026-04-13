output "arn" {
  description = "ALBのARN"
  value       = aws_lb.this.arn
}

output "dns_name" {
  description = "ALBのDNS名"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "ALBのHosted Zone ID"
  value       = aws_lb.this.zone_id
}
