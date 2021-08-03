resource "aws_instance" "ec2_ftp" {
  # count = var.ftp_count
  ami = var.ec2_ami
  key_name = var.key
  instance_type = var.ftp_type
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
      Name    = "${var.ftp_tag}01"
      # Name    = "${var.ftp_tag}0${count.index+1}"
    }
  }
  vpc_security_group_ids = [aws_security_group.ftp.id]
  # subnet_id     = var.azs[count.index % 3]
  subnet_id     = var.azs[0]
  disable_api_termination = var.protect_enable
  tags = {
    Name    = "${var.ftp_tag}01"
  }
}

resource "aws_eip" "ec2_ftp" {
  # instance = aws_instance.ec2_ftp[0].id
  instance = aws_instance.ec2_ftp.id
  vpc      = true
  tags = {
    Name    = var.ftp_tag
  }
}

resource "aws_security_group" "ftp" {
  name        = var.ftp_tag
  description = "${var.ftp_tag} sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    #security_groups = [var.admin_sg]
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "ssh"
  }
  ingress {
    from_port       = 20
    to_port         = 21
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "ftp"
  }
  ingress {
    from_port       = 50000
    to_port         = 50100
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "ftp_pasv"
  }
  ingress {
    from_port       = 10050
    to_port         = 10051
    protocol        = "tcp"
    security_groups = [var.admin_sg]
    description     = "zabbix"
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.ftp_tag
  }
}

output "ec2_ftp" {
  # value = aws_instance.ec2_ftp.*.private_ip
  value = aws_instance.ec2_ftp.private_ip
}
output "instance_id" {
  # value = aws_instance.ec2_ftp.*.id
  value = aws_instance.ec2_ftp.id
}
output "ftp_sg" {
  value = aws_security_group.ftp.id
}