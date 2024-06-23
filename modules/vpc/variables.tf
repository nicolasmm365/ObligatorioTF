variable "vpc_cidr" {
  #default = "10.0.0.0/16"
  description = "Direccion y mascara"
}

variable "subnet_a_cidr" {
  #default = "10.0.1.0/24"
  description = "Direccion de primer subred"
}

variable "subnet_b_cidr" {
  #default = "10.0.2.0/24"
  description = "Direccion segunda subred"
}

variable "vpc_aws_az-a" {
  #default = "us-east-1a"
  description = "Zona de Disponibilidad a"
}

variable "vpc_aws_az-b" {
  #default = "us-east-1b"
  description = "Zona de Disponibilidad b"
}

variable "vpc_name" {
  #default = "vpc-obligatorio"
  description = "Nombre del VPC"
}

variable "tag_subnet_a" {
  type = string
  description = "Tag Subnet a"
}

variable "tag_subnet_b" {
  type = string
  description = "Tag Subnet b"
}

variable "tag_igw" {
  type = string
  description = "Tag IGW"
}

variable "tag_rtable" {
  type = string
  description = "Tag Route Table"
}
