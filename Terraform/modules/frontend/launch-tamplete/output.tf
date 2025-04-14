output "frontend-launch-template-id" {
    value = aws_launch_template.frontend-LT.id
}

variable "bucket_name" {
    type = string
  
}