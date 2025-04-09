resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
  

    tags = {
      "Name" = var.vpc_name
    }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids         = [ aws_subnet.frontend_subnet[0].id, aws_subnet.frontend_subnet[1].id ]  # First subnet from each AZ
  security_group_ids = [var.endpoint_sg_id]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids         = [ aws_subnet.frontend_subnet[0].id, aws_subnet.frontend_subnet[1].id ] # First subnet from each AZ
  security_group_ids = [var.endpoint_sg_id]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids         = [ aws_subnet.frontend_subnet[0].id, aws_subnet.frontend_subnet[1].id ] # First subnet from each AZ
  security_group_ids = [var.endpoint_sg_id]
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



resource "aws_subnet" "frontend_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_ip_frontend[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = var.subnet_names_frontend[count.index]
  }
}

resource "aws_subnet" "backend_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_ip_backend[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = var.subnet_names_backend[count.index]
  }
}


resource "aws_subnet" "db_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_ip_db[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = var.subnet_names_db[count.index]
  }
}



resource "aws_subnet" "public" {
  count             = max(length(var.public_subnet_cidrs), length(var.availability_zones))
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = var.availability_zones[count.index]
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

    tags = {
      Name = "${var.availability_zones[count.index]}-nat-gw"
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id 
  }
}

resource "aws_route_table" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = length(aws_nat_gateway.nat-gw) > 0 ? aws_nat_gateway.nat-gw[count.index % length(aws_nat_gateway.nat-gw)].id : null
  }

  tags = {
    Name = "${var.availability_zones[count.index]}-private-RT"
  } 

}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "frontend_association" {
  count = 2
  subnet_id = aws_subnet.frontend_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index % 2].id

}

resource "aws_route_table_association" "backend_association" {
  count = 2
  subnet_id = aws_subnet.backend_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index % 2].id

}

resource "aws_route_table_association" "db_association" {
  count = 2
  subnet_id = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index % 2].id

}