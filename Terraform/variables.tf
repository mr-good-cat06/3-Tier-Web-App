variable "vpc_cidr" {
    type = string
    default = "10.10.10.0/24"
  
}

variable "availability_zones" {
    type = list(string)
    default = [ "ap-northeast-1a", "ap-northeast-1c"]
}

variable "public_subnet_cidrs" {
    type = list(string)
    default = [ "10.10.10.112/28", "10.10.10.128/28" ]
  
}

variable "private_subnet_frontend" {
    type = list(string)
    default = [ "10.10.10.16/28", "10.10.10.64/28"] 
}

variable "private_subnet_backend" {
    type = list(string)
    default = [ "10.10.10.32/28","10.10.10.80/28" ] 
}

variable "private_subnet_db" {
    type = list(string)
    default = [ "10.10.10.48/28", "10.10.10.96/28" ] 
}

variable "subnet_names_frontend" {
    type = list(string)
    default = [ "web-1", "web-2" ]
}

variable "subnet_names_backend" {
    type = list(string)
    default = [ "app-1", "app-2" ]
}

variable "subnet_names_db" {
    type = list(string)
    default = [ "db-1", "db-2" ]
}

variable "project_name" {
    type = string
    default = "3Tier-project"
  
}

variable "ssh_allowed_ip" {
    type = list(string)
    default = [ "0.0.0.0/0" ]
  
}

variable "app_port" {
    type = number
    default = 5000
  
}

variable "Environment" {
    type = string
    default = "dev"
  
}

variable "region" {
    type = string
    default = "ap-northeast-1"
  
}

variable "username" {
    type = string
    default = "admin"
  
}

variable "password" {
    type = string
    default = "Hello123?"
  
}

variable "db_name" {
    type = string
    default = "MyProjectDatabase"
  
}

variable "instance_type" {
    type = string
    default = "t2.micro"
  
}