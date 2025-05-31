provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count                   = 1
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "private" {
  count      = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index + 2}.0/24"
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
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
  ami                    = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2023
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name               = project3
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "workstation"
  }
}

resource "aws_instance" "master" {
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.private[0].id
  key_name               = project3
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "master"
  }
}

resource "aws_instance" "worker" {
  count                  = 2
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.private[count.index].id
  key_name               = project3
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "worker-${count.index + 1}"
  }
}
