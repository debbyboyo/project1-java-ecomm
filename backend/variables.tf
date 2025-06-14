variable "region" {
  default = "us-east-2"
}

variable "key_name" {
  description = "EC2 key pair for SSH access"
  type        = string
}
