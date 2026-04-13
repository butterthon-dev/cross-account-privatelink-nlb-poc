resource "aws_lb" "this" {
  name               = "${var.name_prefix}-nlb"
  load_balancer_type = "network"
  internal           = var.internal
  subnets            = var.subnet_ids
}
