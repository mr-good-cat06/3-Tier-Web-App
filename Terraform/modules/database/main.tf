resource "aws_db_subnet_group" "db-subnet" {
    name = "my-db-subnet-group"
    subnet_ids = var.db_subnet_ids

    tags = {
      "Name" = "My DB Subnet Group"
    }
  
}

resource "aws_db_instance" "database" {
    allocated_storage = 10
    db_name = var.db_name
    engine = "mysql"
    engine_version = "8.0.40"
    instance_class = "db.t3.micro"
    username = var.username
    password = var.password
    db_subnet_group_name = aws_db_subnet_group.db-subnet.name
    skip_final_snapshot  = true
    identifier = "my-database-1"
    vpc_security_group_ids = var.db_sg

    
    
}

