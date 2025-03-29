# data for amazon linux 2023
data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = ["amazon"]  # Important: specify the owner

  filter {
    name   = "name"
    values = ["al2023-ami-*"]  # Pattern for Amazon Linux 2023
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]  # or "arm64" if you need ARM-based instances
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "ec2-11" {
    count = (length(var.private_subnet_ids)-2)
    ami = data.aws_ami.linux_ami.id
    instance_type = "t2.micro"
    subnet_id = element(var.private_subnet_ids, count.index)
    
      # Determine security group based on subnet type/name
  vpc_security_group_ids = [
    contains(["web", "web-1", "web-2"], element(var.subnet_names, count.index)) ? var.web_sg_id : var.app_sg_id
  ]
  
  tags = {
    Name = ("ec2-${element(var.subnet_names, count.index)}")
  }
  
}