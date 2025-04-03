# MAIN.TF - Optimized for eu-north-1 with t3.micro
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"  # Stockholm region
}

# ----- VARIABLES -----
variable "ami_id" {
  description = "Amazon Linux 2023 AMI for eu-north-1"
  type        = string
  default     = "ami-0b4af2367fa3f2066"  # AL2023 in eu-north-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"  # Changed to t3.micro as requested
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "bookstore-key"  # Changed to more specific name
}

variable "my_ip" {
  description = "Your IP for SSH access"
  type        = string
  default     = "0.0.0.0/32"  # IMPORTANT: Change to your IP!
}

# ----- SECURITY GROUP -----
resource "aws_security_group" "bookstore_sg" {
  name        = "bookstore-frontend-sg"
  description = "Allow web and controlled SSH access"

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # React development server
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Restricted SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  # Locked to your IP
  }

  # Full outbound access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bookstore-frontend-sg"
  }
}

# ----- EC2 INSTANCE -----
resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type  # Using t3.micro here
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.bookstore_sg.id]

  # User data script for automatic deployment
  user_data = <<-EOF
              #!/bin/bash
              # Update system
              dnf update -y
              
              # Install Node.js 18.x
              curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
              dnf install -y nodejs
              
              # Install PM2 process manager
              npm install -g pm2
              
              # Clone repository
              git clone https://github.com/TharushikaS/book-store-mern-project_.git /home/ec2-user/app
              cd /home/ec2-user/app/frontend
              
              # Install dependencies and build
              npm install
              npm run build
              
              # Start application and configure auto-start
              pm2 start npm --name "frontend" -- start
              pm2 save
              pm2 startup
              EOF

  tags = {
    Name    = "BookStore-Frontend",
    Project = "MERN-BookStore",
    Environment = "Production"
  }

  # Optimized root volume for eu-north-1
  root_block_device {
    volume_size = 20  # GB
    volume_type = "gp3"
    encrypted   = true
    delete_on_termination = true
  }

  # Enable detailed monitoring for t3.micro
  monitoring = true
}

# ----- ELASTIC IP -----
resource "aws_eip" "frontend_ip" {
  instance = aws_instance.frontend.id
  tags = {
    Name = "bookstore-frontend-ip"
  }
}

# ----- OUTPUTS -----
output "application_url" {
  value       = "http://${aws_eip.frontend_ip.public_dns}"
  description = "Frontend application URL"
}

output "ssh_command" {
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_eip.frontend_ip.public_dns}"
  description = "SSH connection command"
}

output "instance_details" {
  value = {
    public_ip  = aws_eip.frontend_ip.public_ip
    instance_id = aws_instance.frontend.id
    az         = aws_instance.frontend.availability_zone
  }
  description = "Instance connection details"
}
