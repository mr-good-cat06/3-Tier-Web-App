resource "aws_s3_bucket" "this" {
    bucket = var.bucket_name
  
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