provider "aws" {
  region = "us-east-1"  # Replace with your preferred region
}

resource "aws_s3_bucket" "bookstore_bucket" {
  bucket = "my-bookstore-bucket"
  acl = "private"
}
