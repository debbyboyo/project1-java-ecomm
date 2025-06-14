variable "region" {
  default = "us-east-2"
}

variable "key_name" {
  description = "EC2 key pair name for SSH"
  type        = string
  default     = "jesus"
}
