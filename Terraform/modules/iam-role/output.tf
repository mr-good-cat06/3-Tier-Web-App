
# Outputs for use in other modules
output "frontend_instance_profile_name" {
  value = aws_iam_instance_profile.frontend_instance_profile.name
}

output "backend_instance_profile_name" {
  value = aws_iam_instance_profile.backend_instance_profile.name
}