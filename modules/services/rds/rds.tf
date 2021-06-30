resource "aws_db_subnet_group" "db-subnet" {
    name        = var.db_tag
    subnet_ids  = [var.az1, var.az2, var.az3]
    tags = {
        Name = var.db_tag
    }
}

variable "parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = [{ name = "character_set_client", value = "utf8"},
    { name = "character_set_connection", value = "utf8"},
    { name = "character_set_database", value = "utf8"},
    { name = "character_set_results", value = "utf8"},
    { name = "character_set_server", value = "utf8"},
    { name = "collation_connection", value = "utf8_general_ci"},
    { name = "collation_server", value = "utf8_general_ci"},
    { name = "long_query_time", value = "1.2"},
    { name = "slow_query_log", value = "1"},
    { name = "time_zone", value = "Asia/Tokyo"}]
}

resource "aws_db_parameter_group" "mysql-para" {
  name = var.db_tag
  family = "mysql5.7"
  description = var.db_tag

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
}

resource "aws_db_instance" "db" {
  identifier           = var.db_tag
  allocated_storage    = 30
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.31"
  instance_class       = var.db_type
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_pass
  vpc_security_group_ids  = [var.db_sg_id]
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name
  parameter_group_name = aws_db_parameter_group.mysql-para.name
  maintenance_window = "sat:17:00-sat:17:30"
  backup_window      = "16:00-16:30"
  auto_minor_version_upgrade = false
  copy_tags_to_snapshot = true
  backup_retention_period = 7
  delete_automated_backups = true
  storage_encrypted = true
  deletion_protection = var.protect_enable
  performance_insights_enabled = var.pf_enable
  multi_az = var.rds_az_enable
  availability_zone = var.rds_az
  enabled_cloudwatch_logs_exports = ["error","slowquery"]
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.db_tag}-finalsnapshot"

  tags = {
    Name    = var.db_tag
  }
}

output "rds_r53" {
  value = aws_db_instance.db.address
}