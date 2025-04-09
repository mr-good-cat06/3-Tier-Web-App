variable "backend_launch_template_id" {
    type = string
}

variable "backend_subnet_ids_list" {
    type = list(string)
 
}

variable "backend_tg_arn" {
    type = string
}