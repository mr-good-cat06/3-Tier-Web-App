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
    subnet_names = module.vpc.subnet_names
}