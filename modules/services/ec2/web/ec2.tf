resource "aws_instance" "ec2_web" {
  count = var.web_count
  ami = var.ec2_ami
  key_name = var.key
  instance_type = var.web_type
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
      Name    = "${var.web_tag}0${count.index+1}"
    }
  }
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id     = var.azs[count.index % 3]
  disable_api_termination = var.protect_enable
  tags = {
    Name    = "${var.web_tag}0${count.index+1}"
  }
}

resource "aws_security_group" "web" {
  name        = var.web_tag
  description = "${var.web_tag} sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.admin_sg]
    description     = "ssh"
  }
  ingress {
    from_port       = 10050
    to_port         = 10051
    protocol        = "tcp"
    security_groups = [var.admin_sg]
    description     = "zabbix"
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg]
    description     = "http"
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.web_tag
  }
}

output "ec2_web" {
  value = aws_instance.ec2_web.*.private_ip
}
output "instance_id" {
  value = aws_instance.ec2_web.*.id
}
output "web_sg" {
  value = aws_security_group.web.id
}