output "id" {
    value = module.vpc.vpc_id
  
}

output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
  
}

output "instance-id" {
    value = module.ec2.instance-id
}

