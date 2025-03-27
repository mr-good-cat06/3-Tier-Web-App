variable "vpc_cidr" {
    type = string
    default = "10.10.10.0/24"
  
}

variable "availability_zones" {
    type = list(string)
    default = [ "ap-northeast-1a", "ap-northeast-1c"]
}

variable "public_subnet_cidrs" {
    type = list(string)
    default = [ "10.10.10.112/28", "10.10.10.128/28" ]
  
}

variable "private_subnet_cidrs" {
    type = list(string)
    default = [ "10.10.10.16/28", "10.10.10.32/28", "10.10.10.48/28", "10.10.10.64/28", "10.10.10.80/28", "10.10.10.96/28" ] 
}

variable "subnet_names" {
    type = list(string)
    default = [ "web-1", "web-2", "app-1", "app-2", "db-1", "db-2" ]
}
