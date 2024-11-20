provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "vm" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-Node"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y docker.io docker-compose maven
    sudo systemctl start docker
    sudo systemctl enable docker
  EOF
}
