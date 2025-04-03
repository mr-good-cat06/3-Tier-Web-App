resource "aws_launch_template" "frontend-LT" {
    name = "frontend-LT"
    image_id = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [var.web-sg-id]
    block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }
    
}