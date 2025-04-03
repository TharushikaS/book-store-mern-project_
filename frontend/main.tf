# Configure AWS provider
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Create EC2 instance
resource "aws_instance" "frontend_server" {
  ami           = "ami-00128a17819d3b9b0"  # Amazon Linux 2 AMI (adjust for your region)
  instance_type = "t2.micro"
  
  tags = {
    Name = "BookStore-Frontend"
    Project = "MERN-BookStore"
  }

  # Security group configuration
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  # Key pair for SSH access (create this in AWS console first)
  key_name = "ec2-ssh-key"  # Replace with your key pair name
}

# Create security group
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow HTTP/HTTPS and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Consider restricting to your IP for better security
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the instance public IP
output "instance_public_ip" {
  value = aws_instance.frontend_server.public_ip
}
