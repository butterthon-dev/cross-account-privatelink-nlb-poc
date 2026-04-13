output "ecr_dkr_vpc_endpoint_id" {
  description = "ECR DKR用VPCエンドポイントのID"
  value       = aws_vpc_endpoint.ecr_dkr.id
}

output "ecr_api_vpc_endpoint_id" {
  description = "ECR API用VPCエンドポイントのID"
  value       = aws_vpc_endpoint.ecr_api.id
}
