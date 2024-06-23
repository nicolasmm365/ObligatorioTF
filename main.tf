provider "aws" {
  region = var.region
}

module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
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
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.subnet_ids
  alb_sg_id    = module.vpc.alb_sg_id
  appweb_sg_id = module.vpc.appweb_sg_id
  efs_id       = module.efs.efs_id
  db_endpoint  = module.rds.db_endpoint
  db_username  = var.db_username
  db_password  = var.db_password
  db_name      = module.rds.db_name
  key_name     = var.key_name

  depends_on = [ module.vpc, module.efs, module.rds ]
}
