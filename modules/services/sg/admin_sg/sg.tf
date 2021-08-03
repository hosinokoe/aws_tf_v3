resource "aws_security_group" "admin" {
  name        = var.admin_tag
  description = "${var.admin_tag} sg"
  vpc_id = var.vpc_id

  # dynamic "ingress" {
  #   for_each = var.ingress_rules
  #   content {
  #     description      = lookup(ingress.value, "description")
  #     from_port        = lookup(ingress.value, "from_port")
  #     to_port          = lookup(ingress.value, "to_port")
  #     protocol         = lookup(ingress.value, "protocol")
  #     security_groups  = [lookup(ingress.value, "security_groups")]
  #     # security_groups = [var.admin_sg]
      
  #   }
  # }
  dynamic "ingress" {
    for_each = var.ingress_rules_cidr
    content {
      description      = lookup(ingress.value, "description")
      from_port        = lookup(ingress.value, "from_port")
      to_port          = lookup(ingress.value, "to_port")
      protocol         = lookup(ingress.value, "protocol")
      cidr_blocks  = [lookup(ingress.value, "cidr_blocks")]
    }
  }
  # dynamic "egress" {
  #   for_each = var.egress_rules_sg
  #   content {
  #     description      = lookup(egress.value, "description")
  #     from_port        = lookup(egress.value, "from_port")
  #     to_port          = lookup(egress.value, "to_port")
  #     protocol         = lookup(egress.value, "protocol")
  #     security_groups  = [lookup(ingress.value, "security_groups")]
  #   }
  # }
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
  tags = {
    Name = var.admin_tag
  }
}

output "admin_sg_id" {
  value = aws_security_group.admin.id
}