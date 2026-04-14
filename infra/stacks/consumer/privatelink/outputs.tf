output "endpoint_id" {
  description = "VPC Endpoint の ID"
  value       = module.endpoint.id
}

output "endpoint_dns_name" {
  description = "VPC Endpoint のメインDNS名"
  value       = module.endpoint.dns_name
}

output "endpoint_dns_entries" {
  description = "VPC Endpoint の全DNSエントリ"
  value       = module.endpoint.dns_entries
}

output "provider_api_url" {
  description = "Provider API 呼び出し用URL (Endpoint Service private_dns_name が AWS により自動解決される)"
  value       = "https://${var.provider_service_fqdn}"
}
