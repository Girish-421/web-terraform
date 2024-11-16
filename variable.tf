variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "ap-south-1"  # Change this to your preferred region
}

variable "bucket_name" {
  description = "The name of the S3 bucket for static website hosting"
  type        = string
  default     = "girie"  # Ensure the name is globally unique
}

variable "index_html_path" {
  description = "The path to the index.html file on your local system"
  type        = string
  default     = "index.html"  # Update with the correct local path
}

variable "error_html_path" {
  description = "The path to the error.html file on your local system"
  type        = string
  default     = "error.html"  # Update with the correct local path
}
