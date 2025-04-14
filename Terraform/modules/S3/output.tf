output "bucket_id" {
    description = "The ID of the S3 bucket"
    value       = data.aws_s3_bucket.bucket.id
  
}

output "buket_arn" {
    description = "The ARN of the S3 bucket"
    value       = data.aws_s3_bucket.bucket.arn
  
}