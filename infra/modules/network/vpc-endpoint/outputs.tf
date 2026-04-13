output "id" {
  description = "VPCエンドポイントのID"
  value       = aws_vpc_endpoint.this.id
}

output "dns_name" {
  description = "VPCエンドポイントのメインDNS名 (Interface型のみ)"
  value       = var.type == "Interface" ? aws_vpc_endpoint.this.dns_entry[0].dns_name : null
}

output "dns_entries" {
  description = "VPCエンドポイントのDNSエントリ一覧 (Interface型のみ)"
  value       = var.type == "Interface" ? aws_vpc_endpoint.this.dns_entry : []
}
