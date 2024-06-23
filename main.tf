provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "./modules/vpc"
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
  source                 = "./modules/rds"
  id_subnet_a           = module.vpc.id_subnet_a
  id_subnet_b           = module.vpc.id_subnet_b
  db_sg_id              = module.ec2.db_sg_id
  rds_db_username       = var.rds_db_username
  rds_db_password       = var.rds_db_password
  rds_db_name           = var.rds_db_name
  rds_instance_class    = var.rds_instance_class
  rds_tag_name_db       = var.rds_tag_name_db
  rds_engine_version    = var.rds_engine_version
  rds_engine            = var.rds_engine
  rds_storage_type      = var.rds_storage_type
  rds_allocated_storage = var.rds_allocated_storage


}


module "efs" {
  source           = "./modules/efs"
  subnet_a_cidr    = module.vpc.subnet_a_cidr        # Subnet a
  subnet_b_cidr    = module.vpc.subnet_b_cidr        # Subnet b
  efs_sg_id        = module.vpc.efs_sg_id
  db_instance_arn  = module.rds.db_instance_arn

}

module "ec2" {
  source            = "./modules/ec2"
  alb_sg_id         = module.vpc.alb_sg_id
  appweb_sg_id      = module.vpc.appweb_sg_id
  efs_id            = module.efs.efs_id
  db_endpoint       = module.rds.db_endpoint
  db_username       = var.rds_db_username
  db_password       = var.rds_db_password
  db_name           = module.rds.db_name
  key_name          = var.key_name
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
  subnet_a_cidr     = module.vpc.subnet_a_cidr     # Subnet a
  subnet_b_cidr     = module.vpc.subnet_b_cidr     # Subnet b
  vpc_aws_az-a      = var.vpc_aws_az-a             # AZ a
  vpc_aws_az-b      = var.vpc_aws_az-b             # AZ b

}
