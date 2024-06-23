output "id_vpc" {
  value = aws_vpc.vpc_obligatorio.id
}

output "id_subnet_a" {
  value = aws_subnet.subnet_a.id
}

output "id_subnet_b" {
  value = aws_subnet.subnet_b.id
}

output "subnet_a_cidr" {
  value = aws_subnet.subnet_a.cidr_block
}

output "subnet_b_cidr" {
  value = aws_subnet.subnet_b.cidr_block
}

