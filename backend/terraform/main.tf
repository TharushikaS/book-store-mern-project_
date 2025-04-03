provider "aws" {
  region = "us-east-1"  # preferred AWS region
}

# Create an EC2 instance
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-071226ecf16aa7d96"  # Update this to the latest Amazon Linux AMI or other
  instance_type = "t2.micro"
  key_name      = "ec2-backend"  # Specify your existing keypair or create a new one

  # Automatically install backend or app via UserData
  user_data = <<-EOF
              #!/bin/bash
              cd /home/ec2-user
              git clone https://github.com/TharushikaS/book-store-mern-project_
              cd your-backend
              # Run any setup scripts, install dependencies, etc.
              npm install
              npm start
              EOF

  tags = {
    Name = "MyBookstoreBackend"
  }
}


# Output the instance's public IP
output "instance_public_ip" {
  value = aws_instance.my_ec2_instance.public_ip
}

