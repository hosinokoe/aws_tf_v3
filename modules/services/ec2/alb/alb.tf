resource "aws_lb_target_group" "alb_tg" {
  name     = var.alb_tag
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  deregistration_delay = 30
  health_check {
    path = "/health_check"
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${var.alb_tag} tg"
  }
}

resource "aws_alb_target_group_attachment" "alb_attach" {
  count = var.web_count
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = var.target_id[count.index]
  port             = 80
}

resource "aws_lb_listener" "alb_listener" {
 load_balancer_arn = aws_lb.alb.arn
 port              = "80"
 protocol          = "HTTP"
 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.alb_tg.arn
 }
}

# resource "aws_lb_listener" "alb_listener" {
#   #count = var.global_count
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "redirect"
#     target_group_arn = aws_lb_target_group.alb_tg.arn
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

# resource "aws_lb_listener" "alb_listeners" {
#   #count = var.global_count
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.alb_cert
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_tg.arn
#   }
# }

resource "aws_lb" "alb" {
  name               = var.alb_tag
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  # subnets            = [var.az1, var.az2, var.az3]
  subnets            = var.azs
  enable_deletion_protection = var.protect_enable
  tags = {
    Name = "${var.alb_tag}"
  }
}

resource "aws_security_group" "alb_sg" {
  name = "${var.alb_tag} sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all out"
  }
  tags = {
    Name = "${var.alb_tag} sg"
  }
}

#output "ec2_admin_name" {
#  value = aws_instance.admin.tags.Name
#}
output "alb_sg" {
 value = aws_security_group.alb_sg.id
}