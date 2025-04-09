output "backend_lb_id" {
  value = aws_lb.backend.id
}

output "app_target_group_arn" {
  value = aws_lb_target_group.app-tg.arn
}

output "backend_lb_dns_name" {
  value = aws_lb.backend.dns_name
}