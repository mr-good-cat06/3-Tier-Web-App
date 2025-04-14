terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

provider "aws" {
    region = var.region
}

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    region = var.region
    vpc_name = var.project_name
    availability_zones = var.availability_zones
    public_subnet_cidrs = var.public_subnet_cidrs
    subnet_ip_frontend = var.private_subnet_frontend
    subnet_ip_backend = var.private_subnet_backend
    subnet_ip_db = var.private_subnet_db
    subnet_names_frontend = var.subnet_names_frontend
    subnet_names_backend = var.subnet_names_backend
    subnet_names_db = var.subnet_names_db
    endpoint_sg_id = module.security-group.endpoint_sg_id
}

module "security-group" {
    source = "./modules/security-group"
    project_name = var.project_name
    environment = var.Environment
    ssh_allowed_cidrs = var.ssh_allowed_ip
    app_port = var.app_port
    vpc_id = module.vpc.vpc_id
}


module "secret-manager" {
    source = "./modules/secret_manager"
    username = var.username
    password = var.password
    endpoint = module.database.db_endpoint
    dbname = var.db_name
  
}

module "s3-bucket" {
    source = "./modules/S3"
    bucket_name = var.bucket_name

}


module "efs-fs" {
    source = "./modules/EFS"
    project_name = var.project_name
    backend_subnet = module.vpc.backend_subnet_id
    efs_sg = module.security-group.efs-sg-id
}

module "iam-role" {
    source = "./modules/iam-role"
    db_secret_arn = module.secret-manager.secret_arn
}

module "database" {
    source = "./modules/database"
    db_subnet_ids = module.vpc.db_subnet_id
    db_sg = [module.security-group.db_sg_id]
    username = var.username
    password = var.password
    db_name = var.db_name
    

}



######################################################################


module "backend-ec2" {
    source = "./modules/backend/ec2"
    depends_on = [ module.database ]
    backend_instance_profile_name = module.iam-role.backend_instance_profile_name
    backend_subnet_ids = module.vpc.backend_subnet_id
    region = var.region
    backend_sg_id = module.security-group.backend_sg_id
    secret_name = module.secret-manager.secret_name
    username = var.username
    password = var.password
    db_name = var.db_name
    db_endpoint = module.database.db_endpoint
    subnet_names_backend = var.subnet_names_backend
    instance_type = var.instance_type


  
}


module "backend-load-balancing" {
    source = "./modules/backend/load-balancer"
    depends_on = [ module.backend-ec2 ]
    vpc_id = module.vpc.vpc_id
    backend_instance_ids = module.backend-ec2.backend-instance-id
    backend_LB_sg_id = module.security-group.backend-LB-sg-id
    backend_subnet_ids = module.vpc.backend_subnet_id

}


module "backend-launch-template" {
    source = "./modules/backend/launch-tamplete"
    depends_on = [ module.database ]
    instance_type = var.instance_type
    backend_sg_id = module.security-group.backend_sg_id
    region = var.region
    secret_name = module.secret-manager.secret_name
    username = var.username
    password = var.password
    db_name = var.db_name
    db_endpoint = module.database.db_endpoint
    backend_instance_profile_name = module.iam-role.backend_instance_profile_name

}

module "backend-autoscalling" {
    source = "./modules/backend/asg"
    depends_on = [ module.backend-launch-template ]
    backend_launch_template_id = module.backend-launch-template.backend-launch-template-id
    backend_subnet_ids_list = module.vpc.backend_subnet_id
    backend_tg_arn = module.backend-load-balancing.backend_target_group_arn
    
}


module "frontend-ec2" {
    source = "./modules/frontend/ec2"
    depends_on = [ module.backend-ec2 ]
    instance_type = var.instance_type
    frontend_instance_profile_name = module.iam-role.frontend_instance_profile_name
    frontend_subnet_ids = module.vpc.frontend_subnet_id
    subnet_names_frontend = var.subnet_names_frontend
    backend_lb_dns_name = module.backend-load-balancing.backend_lb_dns_name
    frontend_sg_id = module.security-group.frontend_sg_id
    bucket_name = var.bucket_name
}

module "frontend-load-balancing" {
    source = "./modules/frontend/load-balancer"
    depends_on = [ module.frontend-ec2 ]
    vpc_id = module.vpc.vpc_id
    frontend_instance_ids = module.frontend-ec2.frontend-instance-id
    frontend_sg_id = module.security-group.frontend-LB-sg-id
    public_subnet_ids = module.vpc.public_subnet_ids

}

module "frontend-launch-template" {
    source = "./modules/frontend/launch-tamplete"
    depends_on = [ module.backend-ec2 ]
    instance_type = var.instance_type
    frontend_sg_id = module.security-group.frontend_sg_id
    backend_lb_dns_name = module.backend-load-balancing.backend_lb_dns_name
    frontend_instance_profile_name = module.iam-role.frontend_instance_profile_name
    bucket_name = var.bucket_name
    
}


module "frontend-autoscalling" {
    source = "./modules/frontend/asg"
    depends_on = [ module.frontend-launch-template ]
    frontend_launch_template_id = module.frontend-launch-template.frontend-launch-template-id
    frontend_subnet_ids_list = module.vpc.frontend_subnet_id
    frontend_tg_arn = module.frontend-load-balancing.web_target_group_arn


  
}
