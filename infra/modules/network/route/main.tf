resource "aws_route" "this" {
  route_table_id              = var.route_table_id
  destination_cidr_block      = var.destination_cidr_block
  destination_ipv6_cidr_block = var.destination_ipv6_cidr_block
  destination_prefix_list_id  = var.destination_prefix_list_id

  gateway_id           = var.gateway_id
  nat_gateway_id       = var.nat_gateway_id
  vpc_endpoint_id      = var.vpc_endpoint_id
  network_interface_id = var.network_interface_id
  transit_gateway_id   = var.transit_gateway_id
}
