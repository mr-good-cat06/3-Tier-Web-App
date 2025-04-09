variable "db_subnet_ids" {
    type = list(string)
}

variable "db_sg" {
    type = list(string)
}

variable "username" {
    type = string
}

variable "password" {
    type = string
}

variable "db_name" {
    type = string
}