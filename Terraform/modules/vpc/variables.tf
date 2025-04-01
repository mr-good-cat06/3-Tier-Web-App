variable "vpc_cidr" {
    type = string
}

variable "availability_zones" {
    type = list(string)
}

variable "private_subnet_cidrs" {
    type = list(string)
}

variable "public_subnet_cidrs" {
    type = list(string)
  
}

variable "subnet_names" {
    type = list(string)

}

variable "private_subnet_ids" {
    type = list(string)
}

variable "endpoint_sg_id" {
    type = string
  
}

variable "region" {
    type = string
  
}


