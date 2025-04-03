output "instance-id" {
    value = aws_instance.ec2-instance.*.id
}

output "web-instance-id" {
    value = [aws_instance.ec2-instance[0].id, aws_instance.ec2-instance[1].id]
  
}

output "app-instance-id" {
    value = [aws_instance.ec2-instance[2].id, aws_instance.ec2-instance[3].id]
  
}
output "ami-id" {
    value = data.aws_ami.linux_ami.id
  
}