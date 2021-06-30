#resource "aws_instance" "admin" {
#  count = var.admin_count
#  ami = var.ec2_ami
#  key_name = var.key
#  instance_type = var.admin_type
#  credit_specification {
#    cpu_credits = "standard"
#  }
#  ebs_block_device {
#    device_name = "/dev/xvda"
#    volume_size = 30
#    volume_type = "gp3"
#    encrypted = true
#    snapshot_id = "snap-003b466f2f65000b0"
#    tags = {
#      Name    = "${var.admin_tag}"
#    }
#  }
#  vpc_security_group_ids = [var.admin_sg_id]
#  subnet_id     = var.az1
#  disable_api_termination = var.protect_enable
#  tags = {
#    Name    = "${var.admin_tag}"
#  }
#}

#resource "aws_eip" "admin" {
#  instance = aws_instance.admin.id
#  vpc      = true
#  tags = {
#    Name    = "${var.admin_tag}"
#  }
#}

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

#resource "aws_instance" "ec2_bat" {
#  count = var.bat_count
#  ami = var.ec2_ami
#  key_name = var.key
#  instance_type = var.bat_type
#  credit_specification {
#    cpu_credits = "standard"
#  }
#  ebs_block_device {
#    device_name = "/dev/xvda"
#    volume_size = 30
#    volume_type = "gp3"
#    encrypted = true
#    snapshot_id = "snap-003b466f2f65000b0"
#    tags = {
#      Name    = "${var.bat_tag}0${count.index+1}"
#    }
#  }
#  vpc_security_group_ids = [var.bat_sg_id]
#  subnet_id     = count.index > 0 ? var.az2 : var.az1
#  disable_api_termination = var.protect_enable
#  tags = {
#    Name    = "${var.bat_tag}0${count.index+1}"
#  }
#}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.web_tag}-tg"
  port     = 80
  protocol = "HTTP"
  #vpc_id   = data.aws_vpc.default.id
  vpc_id   = var.vpc_id
  deregistration_delay = 30
  health_check {
    path = "/health_check"
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
}

resource "aws_alb_target_group_attachment" "alb_attach" {
  count = var.web_count
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.ec2_web[count.index].id
  port             = 80
}

#resource "aws_lb_listener" "alb_listener" {
#  load_balancer_arn = aws_lb.alb.arn
#  port              = "80"
#  protocol          = "HTTP"
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.alb_tg.arn
#  }
#}

resource "aws_lb_listener" "alb_listener" {
  #count = var.global_count
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.alb_tg.arn
    redirect {
    host        = "#{host}"
    path        = "/#{path}"
    port        = "443"
    protocol    = "HTTPS"
    query       = "#{query}"
    status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_listeners" {
  #count = var.global_count
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_cert
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb" "alb" {
  name               = "${var.web_tag}-alb"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = [aws_security_group.alb_sg.id]
  security_groups    = [var.alb_sg_id]
  subnets            = [var.az1, var.az2, var.az3]
  enable_deletion_protection = var.protect_enable
  tags = {
    Name = "${var.web_tag}-alb"
  }
}

#output "ec2_admin_name" {
#  value = aws_instance.admin.tags.Name
#}
#output "ec2_admin_pip" {
#  value = aws_instance.admin.private_ip
#} 
output "ec2_web" {
  value = aws_instance.ec2_web.*.private_ip
}