variable "private_subnet_ids" {
    type = list(string)
}

variable "subnet_names" {
    type = list(string)
}

variable "web_sg_id" {
    type = string 
}

variable "app_sg_id" {
    type = string
}
variable "iam_instance_profile_name" {
    type = string
  
}

variable "username" {
    type = string
}

variable "password" {
    type = string
  
}

variable "db_name" {
    type = string
  
}

variable "db_endpoint" {
    type = string
  
}

variable "secret_name" {
    type = string
  
}

variable "region" {
    type = string
  
}

variable "backend_lb_dns_name" {
    type = string
  
}