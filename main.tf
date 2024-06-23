provider "aws" {
  region = var.region
}

module "vpc" {
  source       = "./modules/vpc"
#  subnet_cidrs = var.subnet_cidrs
  vpc_cidr        = var.vpc_cidr             # Direccion de Red
  subnet_a_cidr   = var.subnet_a_cidr        # Subnet a
  subnet_b_cidr   = var.subnet_b_cidr        # Subnet b
  vpc_aws_az-a    = var.vpc_aws_az-a         # AZ a
  vpc_aws_az-b    = var.vpc_aws_az-b         # AZ b
  vpc_name        = var.vpc_name             # Nombre del VPC
  tag_subnet_a    = var.tag_subnet_a         # Tag Subnet a
  tag_subnet_b    = var.tag_subnet_b         # Tag Subnet b
  tag_igw         = var.tag_igw              # Tag IGW
  tag_rtable      = var.tag_rtable           # Tag Route Table
}

module "rds" {
  source     = "./modules/rds"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  db_sg_id   = module.vpc.db_sg_id
  db_username = var.db_username
  db_password = var.db_password
  
  depends_on = [ module.vpc ]
}


module "efs" {
  source     = "./modules/efs"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  efs_sg_id  = module.vpc.efs_sg_id
  db_instance_arn = module.rds.db_instance_arn

  depends_on = [ module.vpc, module.rds ]
}

module "ec2" {
  source       = "./modules/ec2"
#  vpc_id       = module.vpc.vpc_id
#  subnet_ids   = module.vpc.subnet_ids
  alb_sg_id    = module.vpc.alb_sg_id
  appweb_sg_id = module.vpc.appweb_sg_id
  efs_id       = module.efs.efs_id
  db_endpoint  = module.rds.db_endpoint
  db_username  = var.db_username
  db_password  = var.db_password
  db_name      = module.rds.db_name
  key_name     = var.key_name
  id_vpc            = module.vpc.id_vpc          # Variable ID de la VPC
  id_subnet_a       = module.vpc.id_subnet_a     # Variable ID de la Subnet a
  id_subnet_b       = module.vpc.id_subnet_b     # Variable ID de la Subnet b
  nombre_sg_lb      = var.nombre_sg_lb           # Nombre del SG del LB
  tag_sg_lb         = var.tag_sg_lb              # Tag del SG del LB
  nombre_sg_appweb  = var.nombre_sg_appweb       # Nombre del SG del Servidor web 
  tag_sg_appweb     = var.tag_sg_appweb          # Tag del SG del Servidor web
  nombre_sg_mysql   = var.nombre_sg_mysql        # Nombre del SG de MySql 
  tag_sg_mysql      = var.tag_sg_mysql           # Tag del SG de MySql
  nombre_sg_efs     = var.nombre_sg_efs          # Nombre del SG del EFS 
  tag_sg_efs        = var.tag_sg_efs             # Tag del SG del EFS 

  depends_on = [ module.vpc, module.efs, module.rds ]
}
