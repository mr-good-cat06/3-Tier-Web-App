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

resource "aws_instance" "frontend-ec2-instance" {
    count = 2
    ami = data.aws_ami.frontend-ami.id
    instance_type = "t2.micro"
    iam_instance_profile = var.iam_instance_profile_name
    subnet_id = element(var.private_subnet_ids, count.index)
    
  tags = {
    Name = ("ec2-${element(var.subnet_names, count.index)}")
  }
  
}


resource "aws_instance" "backend-ec2-instance" {
    count = 2
    ami = data.aws_ami.backend-ami.id
    instance_type = "t2.micro"
    iam_instance_profile = var.iam_instance_profile_name
    subnet_id = element(var.private_subnet_ids, count.index+2)
    user_data = base64encode(templatefile("./modules/launch_tamplete/backend_script.sh", {
      region = var.region
      secret_name = var.secret_name
      user = var.username
      pass = var.password
      db_name = var.db_name
      db_endpoint = var.db_endpoint


    }))
      # Determine security group based on subnet type/name
  vpc_security_group_ids = compact([
    contains(["app"], element(var.subnet_names, count.index+2)) ? var.app_sg_id : null,
  ])
  
  tags = {
    Name = ("ec2-${element(var.subnet_names, count.index+2)}")
  }
  
}