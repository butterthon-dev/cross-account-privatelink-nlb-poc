resource "aws_acm_certificate_validation" "this" {
  certificate_arn = var.certificate_arn
}
