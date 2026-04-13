output "ecr_repository_url" {
  description = "ECRリポジトリのURL"
  value       = module.ecr.repository_url
}

output "cluster_id" {
  description = "ECSクラスターのID"
  value       = module.cluster.id
}

output "service_name" {
  description = "ECSサービス名"
  value       = module.service.service_name
}
