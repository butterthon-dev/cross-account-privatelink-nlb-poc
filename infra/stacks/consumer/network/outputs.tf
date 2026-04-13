output "vpc_id" {
  description = "VPCのID"
  value       = module.vpc.id
}

output "private_subnet_ids" {
  description = "プライベートサブネットのIDリスト"
  value       = [for s in module.private_subnet : s.id]
}

output "public_subnet_ids" {
  description = "パブリックサブネットのIDリスト"
  value       = [for s in module.public_subnet : s.id]
}

output "ecs_security_group_id" {
  description = "ECS用セキュリティグループのID"
  value       = module.ecs_sg.id
}

output "alb_security_group_id" {
  description = "ALB用セキュリティグループのID"
  value       = module.alb_sg.id
}
