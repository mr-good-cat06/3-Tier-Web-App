output "bucket_id" {
    description = "The ID of the S3 bucket"
    value       = aws_s3_bucket.this.id
}

output "buket_arn" {
    description = "The ARN of the S3 bucket"
    value       = aws_s3_bucket.this.arn
}