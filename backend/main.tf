# Kubernetes Master in public subnet (for SSH access)
resource "aws_instance" "k8s_master" {
  ami                         = "ami-0c2b8ca1dad447f8a"
  instance_type               = "t2.medium"
  key_name                    = "butter"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  tags = {
    Name = "k8s-master"
  }
}

# Kubernetes Worker 1 in private subnet 1
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

# Kubernetes Worker 2 in private subnet 2
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
