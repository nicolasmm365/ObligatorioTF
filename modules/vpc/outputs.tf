output "vpc_id" {
  value = aws_vpc.vpc_obligatorio.id
}

output "id_vpc" {
  value = aws_vpc.vpc_obligatorio
}

output "id_subnet_a" {
  value = aws_subnet.subnet_a.id
}

output "id_subnet_b" {
  value = aws_subnet.subnet_b.id
}
