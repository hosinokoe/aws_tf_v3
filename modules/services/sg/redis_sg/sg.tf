resource "aws_security_group" "redis_sg" {
    name = var.redis_tag
    vpc_id = var.vpc_id
    ingress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        security_groups = [var.bat_sg,var.web_sg,var.admin_sg]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = var.redis_tag
    }
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}