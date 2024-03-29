locals {
  region = "eu-central-1"
  cidr   = "192.168.69.0/24" # nice
}

provider "aws" {
  region = local.region
}

variable "ami" {
  type    = string
  default = "ami-0faab6bdbac9486fb"
}

variable "instance_type" {
  type    = string
  default = "t3a.small"
}

variable "key_name" {
  type    = string
  default = null
}

variable "root_volume_size" {
  default = "20"
}

module "ssh_key" {
  count  = var.key_name == null ? 1 : 0
  source = "./ssh_key"
}

module "vpc" {
  source = "./vpc"
  cidr   = local.cidr
}

resource "aws_instance" "scratch_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name == null ? module.ssh_key[0].key_name : var.key_name
  subnet_id                   = module.vpc.subnet_id
  vpc_security_group_ids      = [module.vpc.security_group_id]
  user_data                   = file("setup.sh")
  associate_public_ip_address = true

  tags = {
    Name = "scratch_instance"
  }

  root_block_device {
    volume_size = var.root_volume_size
  }
}

data "external" "wait_for_up" {
  program    = ["./wait_for_up.sh", aws_instance.scratch_instance.public_ip]
  depends_on = [aws_instance.scratch_instance]
}

output "instance_ip_addr" {
  value = aws_instance.scratch_instance.public_ip
}
