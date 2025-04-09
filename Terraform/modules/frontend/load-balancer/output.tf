output "frontend_lb_id" {
  value = aws_lb.frontend.id
}

output "web_target_group_arn" {
  value = aws_lb_target_group.web-tg.arn
}

output "frontend_lb_dns_name" {
  value = aws_lb.frontend.dns_name
}

