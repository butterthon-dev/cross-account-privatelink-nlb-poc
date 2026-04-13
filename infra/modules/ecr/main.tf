resource "aws_ecr_repository" "this" {
  name                 = "${var.name_prefix}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
