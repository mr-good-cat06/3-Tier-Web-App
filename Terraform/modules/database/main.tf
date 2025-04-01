resource "aws_db_subnet_group" "db-subnet" {
    name = "my-db-subnet-group"
    subnet_ids = var.private_subnet_ids

    tags = {
      "Name" = "My DB Subnet Group"
    }
  
}

resource "aws_db_instance" "database" {
    allocated_storage = 10
    db_name = "mydb"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t2.micro"
    username = "admin"
    password = "password"
    db_subnet_group_name = aws_db_subnet_group.db-subnet.name
    
}

