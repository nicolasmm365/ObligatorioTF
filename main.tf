provider "aws" {
  region = "us-east-1"
}

# Crear una nueva VPC
resource "aws_vpc" "vpc_obligatorio" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-obligatorio"
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
  ingress {
    from_port   = 22
    to_port     = 22
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

# Crear un Internet Gateway
resource "aws_internet_gateway" "obligatorio_igw" {
  vpc_id = aws_vpc.vpc_obligatorio.id

  tags = {
    Name = "obligatorio-igw"
  }
}

# Crear subredes en la zona de disponibilidad A y B dentro de la nueva VPC
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc_obligatorio.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc_obligatorio.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet-b"
  }
}

# Crear grupo de subredes para la base de datos dentro de la nueva VPC
resource "aws_db_subnet_group" "obligatorio_db_subnet_group" {
  name       = "obligatorio-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
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

# Crear un balanceador de carga de aplicación (ALB)
resource "aws_lb" "obligatorio_alb" {
  name               = "obligatorio-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_sg_lb_obligatorio.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Name = "obligatorio-alb"
    Environment = "production"

  }
}

# Definir reglas de escucha y destino para el ALB
resource "aws_lb_listener" "obligatorio_listener" {
  load_balancer_arn = aws_lb.obligatorio_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.obligatorio_target_group.arn
  }
}

# Crear grupos de destino para las instancias de aplicación en las zonas de disponibilidad A y B
resource "aws_lb_target_group" "obligatorio_target_group" {
  name        = "obligatorio-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_obligatorio.id
  target_type = "instance"

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    Name = "obligatorio-target-group"
  }
}

# Agregar instancias de aplicación a los grupos de destino


locals {
  instances = [
    aws_instance.app01,
    aws_instance.app02
  ]
}

resource "aws_lb_target_group_attachment" "obligatorio_target_group" {
  for_each = { for idx, instance in local.instances : idx => instance }

  target_group_arn = aws_lb_target_group.obligatorio_target_group.arn
  target_id        = each.value.id
  port             = 80
}



resource "aws_lb_listener_rule" "obligatorio_listener-rule" {
  listener_arn = aws_lb_listener.obligatorio_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.obligatorio_target_group.arn

  }
  condition {
    path_pattern {
      values = ["/var/www/html/index.html"]
    }
  }
}

resource "aws_db_instance" "obligatorio-db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.44" 
  instance_class       = "db.t3.micro"  
  username             = "admin"
  password             = "password"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.tf_sg_mysql_obligatorio.id]
  db_subnet_group_name = aws_db_subnet_group.obligatorio_db_subnet_group.name

  tags = {
    Name = "obligatorio-db"
  }
}

# Provisionar las instancias de aplicación en las zonas de disponibilidad A y B
resource "aws_instance" "app01" {
  ami           = "ami-02aead0a55359d6ec"
  vpc_security_group_ids = [aws_security_group.tf_sg_appweb_obligatorio.id]
  instance_type = "t2.micro"
  key_name	= "vockey"
  associate_public_ip_address = true
  subnet_id     = aws_subnet.subnet_a.id
  tags = {
    Name = "app01"
    terraform = "True"
  }

  depends_on = [aws_db_instance.obligatorio-db]

 connection {
    type     = "ssh"
    user     = "ec2-user"
    host     = self.public_ip
    private_key = file("C:\\labsuser.pem")
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable epel",
      "sudo yum install epel-release",
      "sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm",
      "sudo yum-config-manager --enable remi-php54",
      "sudo yum install php php-cli php-common php-mbstring php-xml php-mysql php-fpm",
      "sudo yum install httpd git",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "git clone https://github.com/ORT-FI-7417-SolucionesCloud/php-ecommerce-obligatorio.git",
      "cp -r php-ecommerce-obligatorio/* /var/www/html/",
      "sudo vim /var/www/html/config.php"
      "<?php
	ini_set('display_errors',1);
	error_reporting(-1);
	define('DB_HOST', '${aws_db_instance.obligatorio-db.endpoint}');
    define('DB_USER', '${aws_db_instance.obligatorio-db.username}');
    define('DB_PASSWORD', '${aws_db_instance.obligatorio-db.password}');
    define('DB_DATABASE', '${aws_db_instance.obligatorio-db.name}');
?>%",
      # En caso de que falle la creacion del archivo, podemos usar los siguientes comandos para copiarlo
      #provisioner "file" {
      # source      = "repo/config.php"
      # destination = "/var/www/html/config.php"
      #}
      "sudo yum install php-mysql.x86_64",
      "sudo yum install mariadb.x86_64",
      "mysql -h ${aws_db_instance.obligatorio-db.endpoint} -u ${aws_db_instance.obligatorio-db.username} -p${aws_db_instance.obligatorio-db.password} ${aws_db_instance.obligatorio-db.name} < /var/www/html/dump.sql",
      "sudo systemctl restart httpd"
    ]
  }
}

resource "aws_instance" "app02" {
  ami           = "ami-02aead0a55359d6ec"
  vpc_security_group_ids = [aws_security_group.tf_sg_appweb_obligatorio.id]
  instance_type = "t2.micro"
  key_name	= "vockey"
  subnet_id     = aws_subnet.subnet_b.id
  associate_public_ip_address = true
  tags = {
    Name = "app02"
    terraform = "True"
  }

 connection {
    type     = "ssh"
    user     = "ec2-user"
    host     = self.public_ip
    private_key = file("C:\\labsuser.pem")
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable epel",
      "sudo yum install epel-release",
      "sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm",
      "sudo yum-config-manager --enable remi-php54",
      "sudo yum install php php-cli php-common php-mbstring php-xml php-mysql php-fpm",
      "sudo yum install httpd git",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "git clone https://github.com/ORT-FI-7417-SolucionesCloud/php-ecommerce-obligatorio.git",
      "cp -r php-ecommerce-obligatorio/* /var/www/html/",
      "sudo vim /var/www/html/config.php"
      "<?php
	ini_set('display_errors',1);
	error_reporting(-1);
	define('DB_HOST', '${aws_db_instance.obligatorio-db.endpoint}');
    define('DB_USER', '${aws_db_instance.obligatorio-db.username}');
    define('DB_PASSWORD', '${aws_db_instance.obligatorio-db.password}');
    define('DB_DATABASE', '${aws_db_instance.obligatorio-db.name}');
?>%",
      "sudo yum install php-mysql.x86_64",
      "sudo yum install mariadb.x86_64",
      "sudo systemctl restart httpd"
    ]
  }
}

resource "aws_efs_file_system" "efs_obligatorio" {
  creation_token = "FileSystem"

  tags = {
    Name = "FileSystem"
  }
}

resource "aws_efs_backup_policy" "backup_policy" {
  file_system_id = aws_efs_file_system.efs_obligatorio.id

  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  file_system_id = aws_efs_file_system.efs_obligatorio.id
  subnet_id     = aws_subnet.subnet_b.id
  security_groups = [aws_security_group.tf_sg_efs_obligatorio.id]
}
