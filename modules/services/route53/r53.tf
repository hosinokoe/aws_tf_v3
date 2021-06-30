resource "aws_route53_zone" "private" {
  name = "${var.hostzone}"

  vpc {
    vpc_id = data.aws_vpc.default.id
  }
}

resource "aws_route53_record" "redis" {
  zone_id = aws_route53_zone.private.id
  name    = var.redis_tag
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elasticache_replication_group.redis.primary_endpoint_address]
}