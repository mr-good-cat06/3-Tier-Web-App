data "aws_ami" "backend-ami" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["B-image1"]
  }
  
}

resource "aws_instance" "backend-ec2-instance" {
    count = 2
    ami = data.aws_ami.backend-ami.id
    instance_type = var.instance_type
    iam_instance_profile = var.backend_instance_profile_name
    subnet_id = element(var.backend_subnet_ids, count.index)
    user_data = base64encode(templatefile("./modules/backend/launch-tamplete/backend_script.sh", {
      region = var.region
      secret_name = var.secret_name
      user = var.username
      pass = var.password
      db_name = var.db_name
      db_endpoint = var.db_endpoint


    }))
    vpc_security_group_ids = var.backend_sg_id

  
  tags = {
    Name = ("ec2-${element(var.subnet_names_backend, count.index)}")
  }
  
}