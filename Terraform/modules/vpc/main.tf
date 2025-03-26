resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
}


/*
resource "aws_subnet" "private_subnet" {
    for_each = {for idx, cidr in var.private_subnet_cidr : idx => cidr}
    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = var.availability_zone[each.key % length(var.availability_zone)]

    tags = {
    Name = var.subnet_names[each.key]
  }
}

*/



resource "aws_subnet" "private" {
  count             = max(length(var.private_subnet_cidrs), length(var.availability_zones))
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = var.subnet_names[each.key]
  }
}


