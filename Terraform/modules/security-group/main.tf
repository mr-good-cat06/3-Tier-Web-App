# Security Group Module
# Using recommended aws_vpc_security_group_ingress_rule and aws_vpc_security_group_egress_rule

locals {
  # Define common tags for all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Web Server Security Group
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web servers"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-web-sg"
    }
  )
}

# Web Security Group Rules
resource "aws_vpc_security_group_ingress_rule" "web_http" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "web_https" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow HTTPS from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "web_ssh" {
  for_each = toset(var.ssh_allowed_cidrs)
  
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH from ${each.value}"
}

resource "aws_vpc_security_group_egress_rule" "web_all_out" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
  description       = "Allow all outbound traffic"
}

# Application Server Security Group
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for application servers"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-app-sg"
    }
  )
}

# App Security Group Rules
resource "aws_vpc_security_group_ingress_rule" "app_from_web" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.backend-LB.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
  description                  = "Allow traffic from web tier"
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh" {
  for_each = toset(var.ssh_allowed_cidrs)
  
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH from ${each.value}"
}



resource "aws_vpc_security_group_egress_rule" "app_all_out" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
  description       = "Allow all outbound traffic"
}

# Database Security Group
resource "aws_security_group" "database" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for database instances"
  vpc_id      = var.vpc_id


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-db-sg"
    }
  )
}

# Database Security Group Rules
resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "Allow MySQL from app tier"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ping" {
  security_group_id = aws_security_group.database.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "icmp"
  from_port = -1
  to_port = -1
}

resource "aws_vpc_security_group_egress_rule" "db_all_out" {
  security_group_id = aws_security_group.database.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
  description       = "Allow all outbound traffic"
}

resource "aws_security_group" "endpoint-sg" {
  name        = "${var.project_name}-endpoint-sg"
  description = "Security group for endpoint instances"
  vpc_id      = var.vpc_id
  
}


resource "aws_vpc_security_group_ingress_rule" "endponit-ssh" {
  security_group_id = aws_security_group.endpoint-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH from anywhere"
  
}

resource "aws_vpc_security_group_egress_rule" "endpoint_all_out" {
  security_group_id = aws_security_group.endpoint-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
  description       = "Allow all outbound traffic"
}



resource "aws_security_group" "frontend-LB" {
  name        = "${var.project_name}-frontend-sg"
  description = "Security group for frontend LB"
  vpc_id      = var.vpc_id


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-frontend-LB-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "frontend-LB_http" {
  security_group_id = aws_security_group.frontend-LB.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP from anywhere"
  
}

resource "aws_vpc_security_group_egress_rule" "frontend-LB_all_out" {
  security_group_id = aws_security_group.frontend-LB.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
  description       = "Allow all outbound traffic"
  
}


resource "aws_security_group" "backend-LB" {
  name        = "${var.project_name}-backend-sg"
  description = "Security group for backend LB"
  vpc_id      = var.vpc_id


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-backend-LB-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "backend-LB_all_in" {
  security_group_id = aws_security_group.backend-LB.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow anywhere"
  
}

resource "aws_vpc_security_group_egress_rule" "backend-LB_all_out" {
  security_group_id = aws_security_group.backend-LB.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
  description       = "Allow all outbound traffic"
  
}