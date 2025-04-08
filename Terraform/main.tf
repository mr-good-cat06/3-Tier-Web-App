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
    region = var.region
    vpc_name = var.project_name

}

module "ec2" {
    source = "./modules/ec2"
    private_subnet_ids = module.vpc.private_subnet_ids
    subnet_names = var.subnet_names
    web_sg_id = module.security-group.web_sg_id
    app_sg_id = module.security-group.app_sg_id
    iam_instance_profile_name = module.iam-role.profile_name
    
}


module "security-group" {
    source = "./modules/security-group"
    project_name = var.project_name
    environment = var.Environment
    ssh_allowed_cidrs = var.ssh_allowed_ip
    app_port = var.app_port
    vpc_id = module.vpc.vpc_id

}


module "iam" {
    source = "./modules/iam-role"
    db_secret_arn = module.securit_group.db_secret_arn

}

module "databse" {
    source = "./modules/database"
    db_subnet_ids = module.vpc.db_sunbnet_id-list
    db_sg = [module.security-group.db_sg_id]
    username = var.username
    password = var.password
    db_name = var.db_name

}


module "load-balancing" {
    source = "./modules/Load-Balancer"
    vpc_id = module.vpc.vpc_id
    web-instance-id = module.ec2.web-instance-id
    app-instance-id = module.ec2.app-instance-id
    frontend-sg-id = module.security-group.frontend-sg-id
    backend-sg-id = module.security-group.backend-sg-id
    public_subnet_ids = module.vpc.o_public_subnet_ids
    app_subnet_ids = module.vpc.app_sunbnet_id-list
    
  
}

module "launch_template" {
    source = "./modules/launch_tamplete"
    ami = module.ec2.ami-id
    instance_type = "t2.micro"
    web-sg-id = module.security-group.web_sg_id
    app-sg-id = module.security-group.app_sg_id
    backend_lb_dns_name = module.load-balancing.backend-lb-dns
    region = var.region
    iam_instance_profile_name = module.iam-role.profile_name
    secret_name = module.secret_manager.secret_name
    username = var.username
    password = var.password
    db_name = var.db_name
    db_endpoint = module.databse.db_endpoint
    
  


}

module "asg" {
    source = "./modules/auto-scaling-group"
    frontend-launch-template-id = module.launch_template.frontend-launch-template-id
    web_subnet_ids_list = module.vpc.web_subnet_id-list
    web-tg-arn = module.load-balancing.web-tg-arn
    frontend-LB-id = module.load-balancing.frontend-LB-id
    backend-launch-template-id = module.launch_template.backend-launch-template-id
    backend-LB-id = module.load-balancing.backend-LB-id
    app_subnet_ids_list = module.vpc.app_sunbnet_id-list
    app-tg-arn = module.load-balancing.app-tg-arn
    
}

module "secret-manager" {
    source = "./modules/secret_manager"
    username = var.username
    password = var.password
    endpoint = module.databse.db_endpoint
    dbname = var.db_name
  
}