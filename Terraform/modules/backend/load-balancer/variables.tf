variable "vpc_id" {
    type = string
}
variable "app_instance_ids" {
    type = list(string)
}


variable "backend_sg_id" {
    type = string
  
}

variable "app_subnet_ids" {
    type = list(string)
  
}