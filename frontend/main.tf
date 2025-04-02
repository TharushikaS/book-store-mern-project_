provider "aws" {
  region = "us-east-1"  # Replace with your preferred region
}

# S3 Bucket
resource "aws_s3_bucket" "bookstore_bucket" {
  bucket = "my-bookstore-bucket"
  acl    = "private"
}

# EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-071226ecf16aa7d96"  # Replace with a valid AMI ID
  instance_type = "t2.micro"  # Choose the desired instance type
}
