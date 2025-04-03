variable "frontend-launch-template-id" {
    type = string
}

variable "backend-launch-template-id" {
    type = string
  
}
variable "web_subnet_ids" {
    type = list(string)
  
}

variable "web-tg-arn" {
    type = string
}

variable "frontend-LB-id" {
    type = string
}