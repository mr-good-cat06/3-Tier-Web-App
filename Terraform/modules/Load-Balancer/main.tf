resource "aws_lb_target_group" "web-tg" {
    name = "web-tg"
    protocol = "HTTP"
    port = 80
    vpc_id = var.vpc_id
  
}

resource "aws_lb_target_group" "app-tg" {
    name = "app-tg"
    vpc_id = var.vpc_id
    protocol = "TCP"
    port = 5000
  
}
resource "aws_lb_target_group_attachment" "web-tg-attach" {

    for_each = {
        for k, v in var.web-instance-id
        :k=>v
    }

    target_group_arn = aws_lb_target_group.web-tg.arn
    target_id = each.value

}

resource "aws_lb_target_group_attachment" "app-tg-attach" {
    for_each = {
        for k, v in var.app-instance-id
        :k=>v
    }
    target_group_arn = aws_lb_target_group.app-tg.arn
    target_id = each.value
  
}

resource "aws_lb" "frontend" {
    name = "Frontend-LB"
    load_balancer_type = "application"
    internal = false
    security_groups = [var.frontend-sg-id]
    subnets = var.public_subnet_ids

}

resource "aws_lb" "backend" {
    name = "Backend-lb"
    load_balancer_type = "network"
    internal = true
    subnets = var.app_subnet_ids
    security_groups = [var.backend-sg-id]


  
}

resource "aws_lb_listener" "frontend-listener" {
    load_balancer_arn = aws_lb.frontend.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web-tg.arn
      
    }
}

resource "aws_lb_listener" "backend-listener" {
    load_balancer_arn = aws_lb.backend.arn
    port = "5000"
    protocol = "TCP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app-tg.arn
        
    }
  
}

