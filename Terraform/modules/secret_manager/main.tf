resource "aws_secretsmanager_secret" "db_credentials" {
    name = "db-credentials"
  
}

resource "aws_secretmanager_secret_version" "db_credentials" {
    secret_id = aws_secretsmanager_secret.db_credentials.id
    secret_string = jsonencode({
        username = var.username
        password = var.password
        endpoint = var.endpoint
        dbname = var.dbname
    })
}