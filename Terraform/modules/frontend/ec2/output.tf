output "frontend-instance-id" {
    value = aws_instance.frontend-ec2-instance.*.id
  
}