resource "aws_lb_target_group" "nlb_tg" {
  name     = var.nlb_tag
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
  deregistration_delay = 30
  health_check {
    # protocol = "TCP"
    path = "/health_check"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name = "${var.nlb_tag} tg"
  }
}

resource "aws_lb_target_group_attachment" "nlb_attach" {
  count = var.web_count
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = var.target_id[count.index]
  port             = 80
}

resource "aws_lb_listener" "nlb_listener" {
 load_balancer_arn = aws_lb.nlb.arn
 port              = "80"
 protocol          = "TCP"
 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.nlb_tg.arn
 }
}

# resource "aws_lb_listener" "nlb_listener" {
#   #count = var.global_count
#   load_balancer_arn = aws_lb.nlb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "redirect"
#     target_group_arn = aws_lb_target_group.nlb_tg.arn
#     redirect {
#     host        = "#{host}"
#     path        = "/#{path}"
#     port        = "443"
#     protocol    = "HTTPS"
#     query       = "#{query}"
#     status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "nlb_listeners" {
#   #count = var.global_count
#   load_balancer_arn = aws_lb.nlb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.nlb_cert
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.nlb_tg.arn
#   }
# }

resource "aws_lb" "nlb" {
  name               = var.nlb_tag
  internal           = false
  load_balancer_type = "network"
  # security_groups    = [aws_security_group.nlb_sg.id]
  # subnets            = [var.az1, var.az2, var.az3]
  subnets            = var.azs
  enable_deletion_protection = var.protect_enable
  tags = {
    Name = "${var.nlb_tag}"
  }
}

# resource "aws_security_group" "nlb_sg" {
#   name = "${var.nlb_tag} sg"
#   vpc_id = var.vpc_id
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "http"
#   }
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "https"
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "all out"
#   }
#   tags = {
#     Name = "${var.nlb_tag} sg"
#   }
#   lifecycle {
#       create_before_destroy = true
#   }
# }

#output "ec2_admin_name" {
#  value = aws_instance.admin.tags.Name
#}
# output "nlb_sg" {
#  value = aws_security_group.nlb_sg.id
# }