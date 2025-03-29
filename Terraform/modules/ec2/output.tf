output "instance-id" {
    value = aws_instance.ec2-11.*.id
}