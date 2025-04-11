resource "aws_autoscaling_group" "frontend_asg" {
    name = "Frontend Auto Scaling Group"
    max_size = 4
    min_size = 1
    desired_capacity = 1
    health_check_grace_period = 300
    health_check_type = "ELB"
    force_delete = true
    launch_template {
        id = var.frontend_launch_template_id
        version = "$Latest"

    }
    tag {
        key = "Name"
        value = "Application Frontend"
        propagate_at_launch = true
    }

    vpc_zone_identifier = var.frontend_subnet_ids_list
}

resource "aws_autoscaling_attachment" "frontend-asg-attach" {
    autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
    lb_target_group_arn = var.frontend_tg_arn
}
