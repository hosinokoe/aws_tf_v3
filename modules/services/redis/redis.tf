resource "aws_elasticache_subnet_group" "redis-subnet" {
  name       = var.redis_tag
  subnet_ids  = var.az3 == null ? [var.az1, var.az2] : [var.az1, var.az2, var.az3]
}

resource "aws_elasticache_parameter_group" "redis-group" {
  name   = var.redis_tag
  description = var.redis_tag
  family = "redis${var.redis_para}"

  parameter {
    name  = "timeout"
    value = "60"
  }
}

resource "aws_elasticache_replication_group" "redis" {
  auto_minor_version_upgrade    = false
  at_rest_encryption_enabled    = false
  #at_rest_encryption_enabled    = true
  transit_encryption_enabled    = false
  automatic_failover_enabled    = var.failover_enalbe
  multi_az_enabled              = var.redis_az_enable
  engine                        = "redis"
  engine_version                = var.redis_version
  replication_group_id          = var.redis_tag
  replication_group_description = var.redis_tag
  node_type                     = var.redis_type
  number_cache_clusters         = 2
  parameter_group_name          = aws_elasticache_parameter_group.redis-group.name
  subnet_group_name             = aws_elasticache_subnet_group.redis-subnet.name
  maintenance_window            = "sat:18:00-sat:19:00"
  snapshot_retention_limit      = 5
  snapshot_window               = "16:00-17:00"
  security_group_ids            = [var.redis_sg_id]
}

output "redis_r53" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}