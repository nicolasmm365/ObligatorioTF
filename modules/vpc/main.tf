resource "aws_vpc" "vpc_obligatorio" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc_obligatorio.id
  cidr_block        = var.subnet_a_cidr
  availability_zone = var.vpc_aws_az-a
  map_public_ip_on_launch = true
  tags = {
    Name = var.tag_subnet_a
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc_obligatorio.id
  cidr_block        = var.subnet_b_cidr
  availability_zone = var.vpc_aws_az-b
  map_public_ip_on_launch = true
  tags = {
    Name = var.tag_subnet_b
  }
}

resource "aws_security_group" "tf_sg_lb_obligatorio" {
  name = var.nombre_sg_lb
  vpc_id = var.id_vpc
  ingress {
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
    Name = var.tag_sg_lb
  }
}

resource "aws_security_group" "tf_sg_appweb_obligatorio" {
  name = var.nombre_sg_appweb
  vpc_id = var.id_vpc
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups  = [aws_security_group.tf_sg_lb_obligatorio.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.tag_sg_appweb
  }
}

resource "aws_security_group" "tf_sg_mysql_obligatorio" {
  name        = var.nombre_sg_mysql
  description = "Security group MySQL"
  vpc_id      = aws_vpc.vpc_obligatorio.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups  = [aws_security_group.tf_sg_appweb_obligatorio.id]
  }
  tags = {
    Name = var.tag_sg_mysql
  }
}

resource "aws_security_group" "tf_sg_efs_obligatorio" {
  name        = var.nombre_sg_efs
  description = "Security group EFS"
  vpc_id      = var.id_vpc

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups  = [aws_security_group.tf_sg_appweb_obligatorio.id]
  }
}

resource "aws_internet_gateway" "obligatorio_igw" {
  vpc_id = aws_vpc.vpc_obligatorio.id

  tags = {
    Name = var.tag_igw
  }
}

resource "aws_route_table" "route_table_obligatorio" {
  vpc_id = aws_vpc.vpc_obligatorio.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obligatorio_igw.id
  }
  tags = {
    Name = var.tag_rtable
  }
}

resource "aws_route_table_association" "subnet_a_assoc" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_table_obligatorio.id
}

resource "aws_route_table_association" "subnet_b_assoc" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_table_obligatorio.id
}
