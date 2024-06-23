output "id_vpc" {
  description = "ID del VPC"
  value = aws_vpc.vpc_obligatorio.id
}

output "id_subnet_a" {
  description = "ID de la Subnet A"
  value = aws_subnet.subnet_a.id
}

output "id_subnet_b" {
  description = "ID de la Subnet B"
  value = aws_subnet.subnet_b.id
}

output "subnet_a_cidr" {
  description = "CIDR de la Subnet A"
  value = aws_subnet.subnet_a.cidr_block
}

output "subnet_b_cidr" {
  description = "CIDR de la Subnet B"
  value = aws_subnet.subnet_b.cidr_block
}

