output "frontend_sg_id" {
    value = aws_security_group.web.id
}

output "backend_sg_id" {
    value = aws_security_group.app.id
  
}

output "db_sg_id" {
    value = aws_security_group.database.id
}

output "endpoint_sg_id"{
    value = aws_security_group.endpoint-sg.id
}

output "frontend-LB-sg-id" {
    value = aws_security_group.frontend-LB.id
}

output "backend-LB-sg-id" {
    value = aws_security_group.backend-LB.id
  
}


output "efs-sg-id" {
    value = aws_security_group.efs-sg.id
  
}