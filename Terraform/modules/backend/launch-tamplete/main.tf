data "aws_ami" "backend-ami" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["B-image1"]
  }
  
}

resource "aws_launch_template" "backend-LT" {
    name = "backend-LT"
    image_id = data.aws_ami.backend-ami.id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.backend_sg_id]
    user_data = base64encode(templatefile("./modules/launch_tamplete/backend_script.sh", {
      region = var.region
      secret_name = var.secret_name
      user = var.username
      pass = var.password
      db_name = var.db_name
      db_endpoint = var.db_endpoint


    }))

    iam_instance_profile {
      name = var.backend_instance_profile_name
    }

  }

