resource "aws_efs_file_system" "efs_obligatorio" {
  creation_token = "FileSystem"
  tags = {
    Name = "FileSystem"
  }
}

resource "aws_efs_mount_target" "efs_mount_a" {
  file_system_id = aws_efs_file_system.efs_obligatorio.id
  subnet_id      = var.subnet_ids[0]
  security_groups = [var.efs_sg_id]
}

resource "aws_efs_mount_target" "efs_mount_b" {
  file_system_id = aws_efs_file_system.efs_obligatorio.id
  subnet_id      = var.subnet_ids[1]
  security_groups = [var.efs_sg_id]
}

resource "aws_backup_vault" "bk_vault" {
  name = "bk_vault"
  tags = {
    Name = "bk_vault"
  }
}

resource "aws_backup_plan" "bk_plan" {
  name = "bk_plan"

  rule {
    rule_name         = "weekly-backup"
    target_vault_name = aws_backup_vault.bk_vault.name
    schedule          = "cron(0 5 ? * 7 *)" # Semanal a las 5 AM UTC, los domingos
    lifecycle {
      cold_storage_after = 30
      delete_after       = 120
    }
  }
}

resource "aws_backup_selection" "efs_selection" {
  iam_role_arn = "arn:aws:iam::226297523630:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup"
  name         = "efs_selection"
  plan_id      = aws_backup_plan.bk_plan.id

  resources = [
    aws_efs_file_system.efs_obligatorio.arn
  ]
}

resource "aws_backup_selection" "rds_selection" {
  iam_role_arn = "arn:aws:iam::226297523630:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup"
  name         = "rds_selection"
  plan_id      = aws_backup_plan.bk_plan.id

  resources = [
    var.db_instance_arn
  ]
}
