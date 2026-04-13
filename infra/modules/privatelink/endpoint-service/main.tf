resource "aws_vpc_endpoint_service" "this" {
  acceptance_required        = var.acceptance_required
  network_load_balancer_arns = var.network_load_balancer_arns
  allowed_principals         = var.allowed_principals

  tags = {
    Name = "${var.name_prefix}-endpoint-service"
  }
}
