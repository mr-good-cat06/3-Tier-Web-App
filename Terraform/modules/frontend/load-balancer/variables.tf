variable "vpc_id" {
  type = string
}


variable "frontend_sg_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "frontend_instance_ids" {
  type = list(string) 
  
}