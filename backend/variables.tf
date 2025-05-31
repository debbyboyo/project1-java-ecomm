variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  default = "butter"
}

variable "instance_ami" {
  default = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2023 AMI
}

variable "instance_type" {
  default = "t2.medium"
}
