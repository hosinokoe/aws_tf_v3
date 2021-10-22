resource "aws_instance" "admin" {
  ami = var.ec2_ami
  key_name = var.key
  instance_type = var.admin_type
  credit_specification {
    cpu_credits = "standard"
  }
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 30
    volume_type = "gp3"
    encrypted = true
    snapshot_id = var.snapshot_id
    tags = {
      Name    = var.admin_tag
    }
  }
  vpc_security_group_ids = [aws_security_group.admin.id]
  subnet_id     = var.az1
  disable_api_termination = var.protect_enable
  tags = {
    Name    = var.admin_tag
  }
}

resource "aws_eip" "admin" {
  instance = aws_instance.admin.id
  vpc      = true
  tags = {
    Name    = var.admin_tag
  }
}

resource "aws_security_group" "admin" {
  name        = var.admin_tag
  description = "${var.admin_tag} sg"
  vpc_id = var.vpc_id

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
  lifecycle {
      create_before_destroy = true
  }
}

output "admin" {
  value = aws_instance.admin.private_ip
}
output "admin_sg" {
  value = aws_security_group.admin.id
}