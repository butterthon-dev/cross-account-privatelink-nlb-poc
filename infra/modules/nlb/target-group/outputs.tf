output "arn" {
  description = "ターゲットグループのARN"
  value       = aws_lb_target_group.this.arn
}

output "name" {
  description = "ターゲットグループ名"
  value       = aws_lb_target_group.this.name
}
