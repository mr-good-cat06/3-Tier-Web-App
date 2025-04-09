variable "vpc_id" {
    type = string
}
variable "backend_instance_ids" {
    type = list(string)
}


variable "backend_LB_sg_id" {
    type = string
  
}

variable "backend_subnet_ids" {
    type = list(string)
  
}