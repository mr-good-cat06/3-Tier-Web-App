terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

provider "aws" {
    region = "ap-northeast-1"
}

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    availability_zones = var.availability_zones
    private_subnet_cidrs = var.private_subnet_cidrs
    public_subnet_cidrs = var.public_subnet_cidrs
    subnet_names = var.subnet_names
    

}

module "ec2" {
    source = "./modules/ec2"
    private_subnet_ids = module.vpc.private_subnet_ids
    subnet_names = var.subnet_names
}

 


resource "aws_security_group" "database-sg" {
    name = "database-sg"
    vpc_id = module.vpc.id

    tags = {
      Name = "database-sg"
    }
  
}



resource "aws_security_group" "app-12-sg" {
    name = "app-12-sg"
    vpc_id = module.vpc.id

    tags = {
      Name = "app-12-sg"
    }
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql" {
    security_group_id = aws_security_group.app-12-sg.id
    cidr_ipv4 = aws_security_group.web-1-sg.id && aws_security_group.web-2-sg.id
    ip_protocol = "tcp"
    from_port = 3306
    to_port = 3306
  
}



resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.app-12-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "ssh"
    to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_db" {
    security_group_id = aws_security_group.app-12-sg
    cidr_ipv4 = aws_security_group.database-sg.id
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all4" {
    security_group_id = aws_security_group.app-12-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_backend" {
    security_group_id = aws_security_group.database-sg.id
    cidr_ipv4 = aws_security_group.app-12-sg.id
    ip_protocol = "tcp"
    from_port = 3306
    to_port = 5000
  
}

resource "aws_vpc_security_group_egress_rule" "allow_all-1" {
    security_group_id = aws_security_group.database-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

 resource "aws_security_group" "web-1-sg" {
     name = "web-1-sg"
     vpc_id = module.vpc.id

     tags = {
       Name = "web-1-sg"
     }
   
 }

 resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
     security_group_id = aws_security_group.web-1-sg.id
     cidr_ipv4 = "0.0.0.0/0"
     ip_protocol = "ssh"
     to_port = 22
   
 }

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
    security_group_id = aws_security_group.web-1-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
  
}

resource "aws_vpc_security_group_egress_rule" "allow_all2" {
    security_group_id = aws_security_group.web-1-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_security_group" "web-2-sg" {
    name = "web-2-sg"
    vpc_id = module.vpc.id

    tags = {
      Name = "web-2-sg"
    }
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.web-2-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "ssh"
    to_port = 22
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
    security_group_id = aws_security_group.web-2-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
  
}

resource "aws_vpc_security_group_egress_rule" "allow_all3" {
    security_group_id = aws_security_group.web-2-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}
