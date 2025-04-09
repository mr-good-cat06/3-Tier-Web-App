output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "frontend_subnet_id" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.frontend_subnet.*.id
}

output "backend_subnet_id" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.backend_subnet.*.id
}

output "db_subnet_id" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.db_subnet.*.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public.*.id
  
}

output "nat_gateway_id" {
  description = "NAT gateway id"
  value = aws_nat_gateway.nat-gw.*.id
  
}

