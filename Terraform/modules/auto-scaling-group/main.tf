resource "aws_placement_group" "frontend-asg-placement" {
    name = "frasg-placement"
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
    placement_group = aws_placement_group.frontend-asg-placement.id
    launch_template {
        id = var.frontend-launch-template-id
        version = "$Latest"

    }

    vpc_zone_identifier = var.web_subnet_ids_list
}

resource "aws_autoscaling_attachment" "frontend-asg-attach" {
    autoscaling_group_name = aws_autoscaling_group.web-asg.id
    elb = var.frontend-LB-id  
}


resource "aws_placement_group" "backend-asg-placement" {
    name = "backend-asg-placement"
    strategy = "cluster"
  
}

resource "aws_autoscaling_group" "app-asg" {
    name = "app-asg"
    max_size = 4
    min_size = 1
    desired_capacity = 2
    health_check_grace_period = 300
    health_check_type = "ELB"
    force_delete = true
    placement_group = aws_placement_group.backend-asg-placement.id
    launch_template {
        id = var.backend-launch-template-id
        version = "$Latest"

    }

    vpc_zone_identifier = var.app_subnet_ids_list
}

resource "aws_autoscaling_attachment" "backend-asg-attach" {
    autoscaling_group_name = aws_autoscaling_group.app-asg.id
    elb = var.backend-LB-id  
}