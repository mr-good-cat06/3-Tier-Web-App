variable "instance_type" {
    type = string
  
}

variable "frontend_instance_profile_name" {
    type = string
  
}

variable "frontend_subnet_ids" {
    type = list(string)
  
}

variable "subnet_names_frontend" {
    type = list(string)
  
}

variable "backend_lb_dns_name" {
    type = string
  
}

variable "frontend_sg_id" {
    type = string
  
}
variable "bucket_name" {
    type = string
  
}