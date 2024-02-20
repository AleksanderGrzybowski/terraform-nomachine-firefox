resource "random_pet" "scratch_key_identifier" {}

resource "tls_private_key" "scratch_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "scratch_key" {
  key_name   = "scratch_key-${random_pet.scratch_key_identifier.id}"
  public_key = tls_private_key.scratch_key.public_key_openssh
}

output "key_name" { value = aws_key_pair.scratch_key.key_name }