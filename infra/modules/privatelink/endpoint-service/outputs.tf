output "id" {
  description = "VPC Endpoint Service の ID"
  value       = aws_vpc_endpoint_service.this.id
}

output "service_name" {
  description = "VPC Endpoint Service 名 (Consumer 側で service_name として使用)"
  value       = aws_vpc_endpoint_service.this.service_name
}

output "private_dns_name_configuration" {
  description = "Private DNS name の所有権検証用レコード設定 (name / type / value / state)"
  value       = aws_vpc_endpoint_service.this.private_dns_name_configuration
}
