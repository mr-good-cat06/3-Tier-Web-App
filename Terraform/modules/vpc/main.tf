resource "aws_vpc" "vpc" {
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
    Name = var.subnet_names[count.index]
  }
}


resource "aws_subnet" "public" {
  count             = max(length(var.public_subnet_cidrs), length(var.availability_zones))
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = var.subnet_names[count.index]
  }
  
}

resource "aws_internet_gateway" "vpc_igw" {
    vpc_id = aws_vpc.vpc.id

}

resource "aws_eip" "nat" {
    count = length(var.public_subnet_cidrs)

}

resource "aws_nat_gateway" "nat-gw" {
    count = length(var.public_subnet_cidrs)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public[count.index].id

    depends_on = [ aws_internet_gateway.vpc_igw ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route = {
    cidr_block = "0.0.0.0/0"
    internet_gateway_id = aws_internet_gateway.vpc_igw.id

    
  }
  
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = length(aws_nat_gateway.nat-gw) > 0 ? aws_nat_gateway.nat-gw[count.index % length(aws_nat_gateway.nat-gw)].id : null
  }
  
  tags = {
    Name = "${var.subnet_names[count.index]}-private-RT"
  } 

}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}


resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id

}