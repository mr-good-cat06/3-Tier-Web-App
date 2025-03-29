variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = "List of CIDR blocks allowed to SSH into instances"
  type        = list(string)
}

variable "app_port" {
  description = "Port that the application listens on"
  type        = number
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  
}
