resource "aws_autoscaling_group" "backend_asg" {
    name = "Backend Auto Scaling Group"
    max_size = 4
    min_size = 1
    desired_capacity = 1
    health_check_grace_period = 300
    health_check_type = "ELB"
    force_delete = true
    launch_template {
        id = var.backend_launch_template_id
        version = "$Latest"

    }

    vpc_zone_identifier = var.backend_subnet_ids_list
}

resource "aws_autoscaling_attachment" "backend-asg-attach" {
    autoscaling_group_name = aws_autoscaling_group.app-asg.name
    lb_target_group_arn = var.backend_tg_arn
}
