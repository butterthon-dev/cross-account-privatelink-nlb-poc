output "vpc_id" {
  description = "VPCのID"
  value       = module.vpc.id
}

output "private_subnet_ids" {
  description = "プライベートサブネットのIDリスト"
  value       = [for s in module.private_subnet : s.id]
}

output "ecs_security_group_id" {
  description = "ECS用セキュリティグループのID"
  value       = module.ecs_sg.id
}
