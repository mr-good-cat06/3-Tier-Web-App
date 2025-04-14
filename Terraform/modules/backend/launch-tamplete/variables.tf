variable "instance_type" {
  type = string
}

variable "backend_sg_id" {
    type = string 
}

variable "region" {
    type = string
}

variable "secret_name" {
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

variable "backend_instance_profile_name" {
    type = string
}

variable "fs_id" {
    type = string
  
}