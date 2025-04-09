variable "vpc_id" {
    type = string
}

variable "web-instance-id" {
    type = list(string)
}

variable "app-instance-id" {
    type = list(string)
}

variable "frontend-sg-id" {
    type = string
  
}

variable "backend-sg-id" {
    type = string
  
}

variable "public_subnet_ids" {
    type = list(string)
  
}

variable "app_subnet_ids" {
    type = list(string)
  
}