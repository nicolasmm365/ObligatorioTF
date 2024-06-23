output "db_instance_arn" {
  value = aws_db_instance.obligatorio-db.arn
}

output "db_endpoint" {
  value = aws_db_instance.obligatorio-db.endpoint
}

output "db_username" {
  value = aws_db_instance.obligatorio-db.username
}

output "db_password" {
  value = aws_db_instance.obligatorio-db.password
}

output "db_name" {
  value = aws_db_instance.obligatorio-db.db_name
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.obligatorio_db_subnet_group.name
}
