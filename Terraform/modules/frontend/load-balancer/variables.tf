variable "vpc_id" {
  type = string
}

variable "web_instance_ids" {
  type = list(string)
}

variable "frontend_sg_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

