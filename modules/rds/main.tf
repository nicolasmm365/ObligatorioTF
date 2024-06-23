resource "aws_db_subnet_group" "obligatorio_db_subnet_group" {
  name       = "obligatorio-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "obligatorio-db-subnet-group"
  }
}

resource "aws_db_instance" "obligatorio-db" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name = aws_db_subnet_group.obligatorio_db_subnet_group.name
  db_name              = var.db_name
  tags = {
    Name = var.tag_name_db
  }
}
