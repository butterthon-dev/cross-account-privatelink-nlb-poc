output "nlb_arn" {
  description = "NLBのARN"
  value       = module.nlb.arn
}

output "nlb_dns_name" {
  description = "NLBのDNS名"
  value       = module.nlb.dns_name
}

output "target_group_arn" {
  description = "NLBターゲットグループのARN"
  value       = module.target_group.arn
}

output "endpoint_service_name" {
  description = "VPC Endpoint Service 名 (Consumer側で service_name として使用)"
  value       = module.endpoint_service.service_name
}
