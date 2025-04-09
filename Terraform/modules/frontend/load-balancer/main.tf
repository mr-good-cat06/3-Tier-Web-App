resource "aws_lb_target_group" "web-tg" {
  name     = "web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "web" {
  for_each = var.web_instance_ids

  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb" "frontend" {
  name               = "frontend-LB"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.frontend_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

