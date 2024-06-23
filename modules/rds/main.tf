resource "aws_db_subnet_group" "obligatorio_db_subnet_group" {
  name       = "obligatorio-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "obligatorio-db-subnet-group"
  }
}

resource "aws_db_instance" "obligatorio-db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.44"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name = aws_db_subnet_group.obligatorio_db_subnet_group.name
  db_name              = "iDukan"
  tags = {
    Name = "obligatorio-db"
  }
}
