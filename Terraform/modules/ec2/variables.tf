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

variable "interface-profile" {
    type = string
  
}