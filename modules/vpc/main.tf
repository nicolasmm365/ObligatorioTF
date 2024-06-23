resource "aws_vpc" "vpc_obligatorio" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-obligatorio"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc_obligatorio.id
  cidr_block        = var.subnet_cidrs[0]
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc_obligatorio.id
  cidr_block        = var.subnet_cidrs[1]
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-b"
  }
}

resource "aws_security_group" "tf_sg_lb_obligatorio" {
  name = "tf_sg_lb_obligatorio"
  vpc_id = aws_vpc.vpc_obligatorio.id
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
    Name = "tf_sg_lb_obligatorio"
  }
}

resource "aws_security_group" "tf_sg_appweb_obligatorio" {
  name = "tf_sg_appweb_obligatorio"
  vpc_id = aws_vpc.vpc_obligatorio.id
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
    Name = "tf_sg_appweb_obligatorio"
  }
}

resource "aws_security_group" "tf_sg_mysql_obligatorio" {
  name        = "tf_sg_mysql_obligatorio"
  description = "Security group MySQL"
  vpc_id      = aws_vpc.vpc_obligatorio.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups  = [aws_security_group.tf_sg_appweb_obligatorio.id]
  }
}

resource "aws_security_group" "tf_sg_efs_obligatorio" {
  name        = "tf_sg_efs_obligatorio"
  description = "Security group EFS"
  vpc_id      = aws_vpc.vpc_obligatorio.id

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
    Name = "obligatorio-igw"
  }
}

resource "aws_route_table" "route_table_obligatorio" {
  vpc_id = aws_vpc.vpc_obligatorio.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obligatorio_igw.id
  }
  tags = {
    Name = "route_table_obligatorio"
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
