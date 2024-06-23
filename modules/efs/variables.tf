variable "vpc_id" {}
variable "subnet_ids" {}
variable "efs_sg_id" {}
variable "db_instance_arn" {
  description = "The ARN of the RDS database instance to be backed up"
  type        = string
}
