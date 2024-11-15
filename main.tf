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

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = var.index_html_path  # Use variable for local path
  content_type = "text/html"
  acl    = "public-read"
}

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "error.html"
  source = var.error_html_path  # Use variable for local path
  acl    = "public-read"
  content_type = "text/html"
}
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}
