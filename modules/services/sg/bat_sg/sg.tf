resource "aws_security_group" "bat" {
  name        = var.bat_tag
  description = "${var.bat_tag} sg"
  vpc_id = var.vpc_id
#  ingress {
#    from_port       = 22
#    to_port         = 22
#    protocol        = "tcp"
#    #security_groups = [aws_security_group.admin.id]
#    security_groups = [var.admin_sg]
#    description     = "admin only"
#  }
#  ingress {
#    from_port       = 10050
#    to_port         = 10051
#    protocol        = "tcp"
#    #security_groups = [aws_security_group.admin.id]
#    security_groups = [var.admin_sg]
#    description     = "zabbix"
#  }

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = lookup(ingress.value, "description")
      from_port        = lookup(ingress.value, "from_port")
      to_port          = lookup(ingress.value, "to_port")
      protocol         = lookup(ingress.value, "protocol")
      #security_groups  = [lookup(ingress.value, "security_groups")]
      security_groups = [var.admin_sg]
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = lookup(egress.value, "description")
      from_port        = lookup(egress.value, "from_port")
      to_port          = lookup(egress.value, "to_port")
      protocol         = lookup(egress.value, "protocol")
      cidr_blocks  = [lookup(egress.value, "cidr_blocks")]
    }
  }

  #egress {
  #  from_port       = 0
  #  to_port         = 0
  #  protocol        = "-1"
  #  cidr_blocks     = ["0.0.0.0/0"]
  #}
  tags = {
    Name = var.bat_tag
  }
}

output "bat_sg_id" {
  value = aws_security_group.bat.id
}