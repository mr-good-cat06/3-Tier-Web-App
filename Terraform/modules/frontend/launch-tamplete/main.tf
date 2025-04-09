data "aws_ami" "frontend-ami" {

  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["F-image"]
  }
}

resource "aws_launch_template" "frontend-LT" {
    name = "frontend-LT"
    image_id = data.aws_ami.frontend-ami.id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.frontend_sg_id]
    
    user_data = base64encode(templatefile("./modules/launch_tamplete/frontend_script.sh", {
      backend_url="http://${var.backend_lb_dns_name}:5000/api" }))

    iam_instance_profile {
      name = var.frontend_instance_profile_name
    }
    
}
