output "endpoint_id" {
  description = "VPC Endpoint の ID"
  value       = module.endpoint.id
}

output "endpoint_dns_name" {
  description = "VPC Endpoint のメインDNS名 (Consumer アプリから PROVIDER_API_URL として利用)"
  value       = module.endpoint.dns_name
}

output "endpoint_dns_entries" {
  description = "VPC Endpoint の全DNSエントリ"
  value       = module.endpoint.dns_entries
}
