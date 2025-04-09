variable "vpc_name" {
    type = string  

}
variable "vpc_cidr" {
    type = string
}

variable "region" {
    type = string  
}

variable "availability_zones" {
    type = list(string)
}

variable "public_subnet_cidrs" {
    type = list(string)
}

variable "subnet_ip_frontend" {
    type = list(string)
  
}

variable "subnet_ip_backend" {
    type = list(string)
  
}

variable "subnet_ip_db" {
    type = list(string)
  
}
  
variable "subnet_names_frontend" {
    type = list(string)
  
}

variable "subnet_names_backend" {
    type = list(string)
  
}
variable "subnet_names_db" {
    type = list(string)
  
}

variable "endpoint_sg_id" {
    type = string
  
}


