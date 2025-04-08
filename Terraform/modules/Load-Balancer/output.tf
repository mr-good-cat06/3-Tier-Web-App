output "frontend-LB-id" {
    value = aws_lb.frontend.id

}

output "backend-LB-id" {
    value = aws_lb.backend.id  
}

output "web-tg-arn" {
    value = aws_lb_target_group.web-tg.arn
}

output "app-tg-arn" {
    value = aws_lb_target_group.app-tg.arn
}

output "frontend-lb-dns" {
    value = aws_lb.frontend.dns_name
  
}

output "backend-lb-dns" {
    value = aws_lb.backend.dns_name
  
}
