
variable "efs_sg_id" {}
variable "db_instance_arn" {
  description = "The ARN of the RDS database instance to be backed up"
  type        = string
}
variable "subnet_a_cidr" {
  #default = "10.0.1.0/24"
  description = "Direccion de primer subred"
}

variable "subnet_b_cidr" {
  #default = "10.0.2.0/24"
  description = "Direccion segunda subred"
}