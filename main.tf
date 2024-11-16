resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name  # Use variable for bucket name
  tags = {
    Name = "StaticWebsiteBucket"
  }
}

resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"  # Define error document
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false  # Allow public ACLs
  block_public_policy     = false  # Allow public bucket policies
  ignore_public_acls      = false  # Do not ignore public ACLs
  restrict_public_buckets = false  # Do not restrict public bucket access
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Removed aws_s3_bucket_acl as it conflicts with ownership controls
# Bucket policies are used instead to manage public access

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = var.index_html_path  # Use variable for local path
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"
  source       = var.error_html_path  # Use variable for local path
  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"  # Apply to all objects in the bucket
      },
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.website_bucket.arn  # Apply to the bucket itself
      }
    ]
  })
}

# IAM Policy for user to access S3 bucket (Optional, if needed)
resource "aws_iam_policy" "s3_permissions_policy" {
  name        = "S3PermissionsPolicy"
  description = "Policy to allow PutBucketPolicy and PutObject actions on the S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutBucketPolicy"
        Resource = "arn:aws:s3:::${aws_s3_bucket.website_bucket.bucket}"
      },
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.website_bucket.bucket}/*"
      }
    ]
  })
}

# Attach the policy to a user or role (example for user)
resource "aws_iam_user" "example_user" {
  name = "example-user"
}

resource "aws_iam_policy_attachment" "example_policy_attachment" {
  name       = "example-policy-attachment"
  policy_arn = aws_iam_policy.s3_permissions_policy.arn
  users      = [aws_iam_user.example_user.name]
}
