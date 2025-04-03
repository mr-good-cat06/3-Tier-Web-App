output "id" {
    value = module.vpc.vpc_id
  
}

output "instance-id" {
    value = module.ec2.instance-id
}

