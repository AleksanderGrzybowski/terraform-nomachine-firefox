variable "cidr" {
  type = string
}

resource "aws_vpc" "scratch_vpc" {
  cidr_block = var.cidr

  tags = { Name = "scratch_vpc" }
}

resource "aws_subnet" "scratch_subnet" {
  vpc_id     = aws_vpc.scratch_vpc.id
  cidr_block = var.cidr

  tags = { Name = "scratch_subnet" }
}

resource "aws_internet_gateway" "scratch_internet_gateway" {
  vpc_id = aws_vpc.scratch_vpc.id

  tags = { Name = "scratch_internet_gateway" }
}

resource "aws_route_table" "scratch_route_table" {
  vpc_id = aws_vpc.scratch_vpc.id

  route {
    gateway_id = aws_internet_gateway.scratch_internet_gateway.id
    cidr_block = "0.0.0.0/0"
  }

  tags = { Name = "my_route_table" }
}

resource "aws_route_table_association" "my_association" {
  subnet_id      = aws_subnet.scratch_subnet.id
  route_table_id = aws_route_table.scratch_route_table.id
}

resource "aws_security_group" "scratch_security_group" {
  name        = "scratch_allow_ssh_and_nomachine"
  description = "Allow SSH and NoMachine inbound traffic"
  vpc_id      = aws_vpc.scratch_vpc.id

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

  ingress {
    description = "HTTP inbound"
    from_port   = 80
    to_port     = 80
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
    Name = "scratch_allow_ssh_and_nomachine"
  }
}

output "vpc_id" {
  value = aws_vpc.scratch_vpc.id
}

output "security_group_id" {
  value = aws_security_group.scratch_security_group.id
}

output "subnet_id" {
  value = aws_subnet.scratch_subnet.id
}