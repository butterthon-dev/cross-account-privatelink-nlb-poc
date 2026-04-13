output "service_name" {
  description = "ECSサービス名"
  value       = aws_ecs_service.this.name
}
