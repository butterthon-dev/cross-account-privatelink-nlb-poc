output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "ALBのHosted Zone ID"
  value       = module.alb.zone_id
}

output "target_group_arn" {
  description = "ターゲットグループのARN"
  value       = module.target_group.arn
}

output "certificate_arn" {
  description = "ACM証明書のARN"
  value       = module.certificate.arn
}

output "certificate_validation_records" {
  description = "ACM DNS検証レコード (Provider側のHosted Zoneに登録する)"
  value       = module.certificate.domain_validation_options
}
