provider "aws" {
  region = "eu-central-1"
}

data "aws_vpc" "default" {
  default = true
} 

# This is a fake throwaway key, just to avoid having one pre-created all the time.
# If you want to use an already existing key, just change "key_name" in instance resource.
resource "aws_key_pair" "scratch_ssh_key" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+J0SBSFc8lMdCbWkXJjOzmcYPElezFWZ6k4DwQb9G/PBH5fobgrTfpjOdgZI6IsxPtGzrf/xa7ncO5Wi8vYDnmStuvlQAfUX7u53ay1EbLmLqxLQekVBbRxwfTu4yGGU8FezfuNCKntkePPtbzsg2JMDJn0/WGl/TxMSrYSF11/c6N7354+Edyiz99GOGJ4JEfGSkz1fa8SVAP7CpSXZbdjV7jNx28f9fdcZCnXWa9Pz47UN80zLY1LpAU7MUgUKeWxaurU785vaew+Vt1+1BvHtlUgHYYmzwkizm92722gvmS1wUSBpGdzZZ2AsvqnJ2OQeVUJameDyAw5X7RmCuSTYlr+mo6ef1dni0Fj8r+vcAt2pOVK8dOOkHSySQzhXPX3MwCpBk+ngVVjB++YIDaZEOzeaD7pBm/o+GoVabd4mq8Q6OsWgPFNTn/bR4eo7S+Lc29DXTkogXo75sWcX9f+rX+gnzzRnyzHv531WvUpDFqb8aGCRD2E7dsbsB/nM= this_is_a_throwaway_key@localhost"
}

resource "aws_security_group" "scratch_security_group" {
  name        = "scratch_allow_ssh_only"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NoMachine inbound"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "scratch_allow_ssh_only"
  }
}

resource "aws_instance" "scratch" {
  ami             = "ami-0502e817a62226e03"
  instance_type   = "t3a.small"
  key_name        = aws_key_pair.scratch_ssh_key.key_name
  security_groups = [aws_security_group.scratch_security_group.name]
  user_data       = file("setup.sh")

  tags = {
    Name = "scratch"
  }
}

output "instance_ip_addr" {
  value = aws_instance.scratch.public_ip
}
