variable "frontend_launch_template_id" {
    type = string
}

variable "frontend_subnet_ids_list" {
    type = list(string)
  
}

variable "frontend_tg_arn" {
    type = string
  
}