variable "vpc_id" {}
variable "subnet_ids" {}
variable "alb_sg_id" {}
variable "appweb_sg_id" {}
variable "efs_id" {}
variable "db_endpoint" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "key_name" {}



variable "id_vpc" {
  type = string
  description = "Para saber el Output ID de la VPC"
}
variable "id_subnet_a" {
  type = string
  description = "ID del Subnet a"
}

variable "id_subnet_b" {
  type = string
  description = "ID del Subnet b"
}

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
