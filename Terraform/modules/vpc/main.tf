resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
}


resource "aws_subnet" "private" {
    for_each = {for idx, cidr in var.private_subnet_cidr : idx => cidr}
    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = var.availability_zone[each.key % length(var.availability_zone)]
}

