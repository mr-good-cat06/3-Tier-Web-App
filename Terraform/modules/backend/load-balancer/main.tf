resource "aws_lb_target_group" "app-tg" {
  name     = "app"
  port     = 5000
  protocol = "TCP"
  vpc_id   = var.vpc_id
  
}

resource "aws_lb_target_group_attachment" "app" {
  for_each = { for idx, id in var.backend_instance_ids : idx => id }

  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = each.value
  port             = 5000
}

resource "aws_lb" "backend" {
  name               = "backend-LB"
  load_balancer_type = "network"
  internal           = true
  security_groups    = [var.backend_LB_sg_id]
  subnets            = var.backend_subnet_ids
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 5000
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}
