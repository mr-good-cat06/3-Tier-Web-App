resource "aws_lb_target_group" "app-tg" {
  name     = "web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "app" {
  for_each = var.backend_instance_ids

  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb" "backend" {
  name               = "backend-LB"
  load_balancer_type = "Network"
  internal           = true
  security_groups    = [var.backend_LB_sg_id]
  subnets            = var.backend_subnet_ids
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}
