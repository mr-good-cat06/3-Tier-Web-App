resource "aws_s3_bucket" "this" {
    bucket = var.bucket_name
  
}

resource "aws_s3_bucket_public_access_block" "s3_block" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "allow_access" {
    statement {
        principals {
            type = "AWS"
            identifiers = ["*"]
        }

        actions = [
            "s3:GetObject",
            "s3:ListBucket"
        ]

        resources = [
            aws_s3_bucket.this.arn,
            "${aws_s3_bucket.this.arn}/*"
        
        ]

    }
}


resource "aws_s3_bucket_policy" "allow_access" {
    bucket = aws_s3_bucket.this.id
    policy = data.aws_iam_policy_document.allow_access.json
}