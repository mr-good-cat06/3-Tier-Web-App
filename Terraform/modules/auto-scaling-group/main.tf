resource "aws_placement_group" "asg-placement" {
    name = "asg-placement"
    strategy = "cluster"
  
}

resource "aws_autoscaling_group" "web-asg" {
    name = "web-asg"
    max_size = 4
    min_size = 1
    desired_capacity = 2
    health_check_grace_period = 300
    health_check_type = "ELB"
    force_delete = true
    placement_group = aws_placement_group.asg-placement.id
    launch_template {
        id = var.frontend-launch-template-id
        version = "$Latest"

    }

    vpc_zone_identifier = var.web_subnet_ids
}

resource "aws_autoscaling_attachment" "frontend-asg-attach" {
    autoscaling_group_name = aws_autoscaling_group.web-asg.id
    elb = var.frontend-LB-id  
}

resource "aws_autoscaling_attachment" "frontend-asg-attach" {
    autoscaling_group_name = aws_autoscaling_group.web-asg.id
    lb_target_group_arn = var.web-tg-arn
  
}