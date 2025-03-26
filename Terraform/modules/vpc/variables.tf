variable "vpc_cidr" {
    type = string
}

variable "availability_zone" {
    type = list(string)
}

variable "private_subnet_cidr" {
    type = list(string)
}

variable "subnet_names" {
    type = list(string)
  
}
