# Frontend EC2 Role - Only SSM access
resource "aws_iam_role" "frontend_ec2_role" {
  name = "frontend-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "frontend_attach_ssm_policy" {
  role       = aws_iam_role.frontend_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "frontend_instance_profile" {
  name = "frontend-ec2-ssm-profile"
  role = aws_iam_role.frontend_ec2_role.name
}

# Backend EC2 Role - Both SSM and Secrets Manager access
resource "aws_iam_role" "backend_ec2_role" {
  name = "backend-ec2-ssm-secret-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "secret_access" {
  name        = "secret-access-policy"
  description = "Allow access to specific DB secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = var.db_secret_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_attach_ssm_policy" {
  role       = aws_iam_role.backend_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "backend_attach_secret_access" {
  role       = aws_iam_role.backend_ec2_role.name
  policy_arn = aws_iam_policy.secret_access.arn
}

resource "aws_iam_instance_profile" "backend_instance_profile" {
  name = "backend-ec2-ssm-secret-profile"
  role = aws_iam_role.backend_ec2_role.name
}
