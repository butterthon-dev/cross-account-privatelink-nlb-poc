output "id" {
  description = "VPC Endpoint Service の ID"
  value       = aws_vpc_endpoint_service.this.id
}

output "service_name" {
  description = "VPC Endpoint Service 名 (Consumer 側で service_name として使用)"
  value       = aws_vpc_endpoint_service.this.service_name
}
