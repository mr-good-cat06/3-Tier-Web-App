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
    endpoint_sg_id = module.security-group.endpoint_sg_id
    private_subnet_ids = module.vpc.private_subnet_ids


    

}

module "ec2" {
    source = "./modules/ec2"
    private_subnet_ids = module.vpc.private_subnet_ids
    subnet_names = var.subnet_names
    web_sg_id = module.security-group.web_sg_id
    app_sg_id = module.security-group.app_sg_id

}

 


module "security-group" {
    source = "./modules/security-group"
    project_name = var.project_name
    environment = var.Environment
    ssh_allowed_cidrs = var.ssh_allowed_ip
    app_port = var.app_port
    vpc_id = module.vpc.vpc_id

}