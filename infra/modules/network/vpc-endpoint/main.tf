resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = var.type
  subnet_ids          = var.type == "Interface" ? var.subnet_ids : null
  security_group_ids  = var.type == "Interface" ? var.security_group_ids : null
  private_dns_enabled = var.type == "Interface" ? var.private_dns_enabled : null
  route_table_ids     = var.type == "Gateway" ? var.route_table_ids : null

  tags = {
    Name = "${var.name_prefix}-vpce"
  }
}
