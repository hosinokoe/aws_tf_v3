resource "aws_instance" "ec2_bat" {
  count = var.bat_count
  ami = var.ec2_ami
  key_name = var.key
  instance_type = var.bat_type
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
      Name    = "${var.bat_tag}0${count.index+1}"
    }
  }
  vpc_security_group_ids = [var.bat_sg_id]
  subnet_id     = count.index > 0 ? var.az2 : var.az1
  disable_api_termination = var.protect_enable
  tags = {
    Name    = "${var.bat_tag}0${count.index+1}"
  }
}

output "ec2_bat" {
  value = aws_instance.ec2_bat.*.private_ip
}