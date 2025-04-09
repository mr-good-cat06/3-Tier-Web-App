

output "web-instance-id" {
    value = [aws_instance.frontend-ec2-instance[0].id, aws_instance.frontend-ec2-instance[1].id]
  
}

output "app-instance-id" {
    value = [aws_instance.backend-ec2-instance[0].id, aws_instance.backend-ec2-instance[1].id]
  
}
