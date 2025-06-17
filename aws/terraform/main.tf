provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "zero-trust-vpc" }
}

resource "aws_subnet" "spire_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.aws_az
  tags = { Name = "spire-subnet" }
}

resource "aws_instance" "spire_host" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.spire_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "spire-server"
  }

  user_data = file("${path.module}/user-data.sh")
}
