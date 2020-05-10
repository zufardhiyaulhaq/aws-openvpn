# AWS Region related vars
variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

# AWS EC2 keypair related vars
variable "aws_keyname" {
  type = string
}

variable "aws_keyfile" {
  type = string
}

# AWS EC2 virtual machine related vars
variable "aws_ami" {
  type = string
}

variable "aws_instancetype" {
  type = string
}

# OpenVPN related vars
variable "ovpn_port" {
  type = number
}

variable "ovpn_protocol" {
  type = string
}
