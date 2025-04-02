output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private.*.id
}

output "o_public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public.*.id
  
}

output "db_sunbnet_id-list" {
  description = "The IDs of the database subnets"
  value = [for sb in aws_subnet.private : sb.id if can(sb.tags.Name) && startswith(sb.tags.Name, "db")]

}