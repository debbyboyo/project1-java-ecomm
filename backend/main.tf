# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "project1-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "project1-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "workstation" {
  ami                         = "ami-0c2b8ca1dad447f8a"
  instance_type               = "t2.micro"
  key_name                    = "butter"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  tags = {
    Name = "terraform-workstation"
  }
}

resource "aws_instance" "k8s_master" {
  ami                         = "ami-0c2b8ca1dad447f8a"
  instance_type               = "t2.medium"
  key_name                    = "butter"
  subnet_id                   = aws_subnet.private_subnet_1.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "k8s_worker_1" {
  ami                         = "ami-0c2b8ca1dad447f8a"
  instance_type               = "t2.medium"
  key_name                    = "butter"
  subnet_id                   = aws_subnet.private_subnet_1.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  tags = {
    Name = "k8s-worker-1"
  }
}

resource "aws_instance" "k8s_worker_2" {
  ami                         = "ami-0c2b8ca1dad447f8a"
  instance_type               = "t2.medium"
  key_name                    = "butter"
  subnet_id                   = aws_subnet.private_subnet_2.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  tags = {
    Name = "k8s-worker-2"
  }
}
