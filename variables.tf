variable "region" {
  description = "The AWS region to create resources in"
  type        = string
}

#variable "vpc_cidr" {
#  description = "The CIDR block for the VPC"
#  type        = string
#}

#variable "subnet_cidrs" {
#  description = "A list of CIDR blocks for the subnets"
#  type        = list(string)
#}

variable "db_username" {
  description = "The username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "The name of the key pair to use for EC2 instances"
  type        = string
}




variable "profile" {
  default     = "default"
  description = "Perfil estandar"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "Region a aplicar"
}

# Variables de Red 
variable "vpc_cidr" {
  #default     = "10.0.0.0/16"
  description = "CIDR del VPC"
}

variable "subnet_a_cidr" {
  #default     = "10.0.1.0/24"
  description = "Direccion de subred a"
}

variable "subnet_b_cidr" {
  #default     = "10.0.2.0/24"
  description = "Direccion de subred b"
}

variable "vpc_aws_az-a" {
  #default     = "us-east-1a"
  description = "Zona de disponibilidad 1"
}

variable "vpc_aws_az-b" {
  #default     = "us-east-1b"
  description = "Zona de disponibilidad 2"
}

variable "vpc_name" {
  #default = "vpc-obligatorio"
  description = "Nombre del VPC"
}

variable "tag_subnet_a" {
  type        = string
  description = "Tag Subnet a"
}

variable "tag_subnet_b" {
  type        = string
  description = "Tag Subnet b"
}

variable "tag_igw" {
  type        = string
  description = "Tag IGW"
}

variable "tag_rtable" {
  type        = string
  description = "Tag Route Table"
}

# Variables EC2 

variable "nombre_sg_lb" {
  type        = string
  description = "Nombre del SG para el LB"
}
variable "tag_sg_lb" {
  type        = string
  description = "Nombre del SG del LB"
}

variable "nombre_sg_appweb" {
  type        = string
  description = "Nombre del SG para del web Server"
}
variable "tag_sg_appweb" {
  type        = string
  description = "Nombre del SG del web Server"
}

variable "nombre_sg_mysql" {
  type        = string
  description = "Nombre del SG para MySql"
}
variable "tag_sg_mysql" {
  type        = string
  description = "Tag del SG de MySql"
}

variable "nombre_sg_efs" {
  type        = string
  description = "Nombre del SG para el EFS"
}
variable "tag_sg_efs" {
  type        = string
  description = "Tag del SG del EFS"
}



variable "instance_class" {}
variable "tag_name_db" {}
variable "db_name" {}
variable "engine_version" {}
variable "engine" {}
variable "storage_type" {}
variable "allocated_storage" {}

