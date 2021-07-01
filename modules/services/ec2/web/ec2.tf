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
  vpc_security_group_ids = [var.web_sg_id]
  #subnet_id     = "${var.subnet_a}"
  subnet_id     = count.index > 0 ? var.az2 : var.az1
  disable_api_termination = var.protect_enable
  tags = {
    Name    = "${var.web_tag}0${count.index+1}"
  }
}

output "ec2_web" {
  value = aws_instance.ec2_web.*.private_ip
}