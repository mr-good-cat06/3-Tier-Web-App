data "aws_ami" "frontend-ami" {

  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["F-image"]
  }
}

data "aws_ami" "backend-ami" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["B-image1"]
  }
  
}




resource "aws_launch_template" "frontend-LT" {
    name = "frontend-LT"
    image_id = data.aws_ami.frontend-ami.id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.web-sg-id]
    
    user_data = base64encode(file("./modules/launch_tamplete/frontend_script.sh", {
      backend_url="http://${var.backend_lb_dns_name}:5000/api" }))
    
}


resource "aws_launch_template" "backend-LT" {
    name = "backend-LT"
    image_id = data.aws_ami.backend-ami.id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.app-sg-id]
    user_data = base64decode(file("./modules/launch_tamplete/backend_script.sh", {
      region = var.region
      secret_name = var.secret_name
    }))

    iam_instance_profile {
      name = var.iam_instance_profile_name
    }

  }
    


