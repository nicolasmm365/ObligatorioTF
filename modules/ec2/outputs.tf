

output "alb_sg_id" {
  value = aws_security_group.tf_sg_lb_obligatorio.id
}

output "appweb_sg_id" {
  value = aws_security_group.tf_sg_appweb_obligatorio.id
}

output "db_sg_id" {
  value = aws_security_group.tf_sg_mysql_obligatorio.id
}

output "efs_sg_id" {
  value = aws_security_group.tf_sg_efs_obligatorio.id
}

