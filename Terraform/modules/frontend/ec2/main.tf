data "aws_ami" "frontend-ami" {

  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["F-image"]
  }
}

resource "aws_instance" "frontend-ec2-instance" {
    count = 2
    ami = data.aws_ami.frontend-ami.id
    instance_type = var.instance_type
    iam_instance_profile = var.frontend_instance_profile_name
    subnet_id = element(var.frontend_subnet_ids, count.index)
    user_data = base64encode(templatefile("./modules/frontend/launch-tamplete/frontend_script.sh", {
      backend_url="http://${var.backend_lb_dns_name}:5000/api" }))
    
    vpc_security_group_ids = [var.frontend_sg_id]

  tags = {
    Name = ("ec2-${element(var.subnet_names_frontend, count.index)}")
  }

  
}
