output "db_instance_arn" {
  value = aws_db_instance.obligatorio-db.arn
}

output "rds_db_endpoint" {
  value = aws_db_instance.obligatorio-db.endpoint
}

output "db_name" {
  value = aws_db_instance.obligatorio-db.db_name
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.obligatorio_db_subnet_group.name
}
