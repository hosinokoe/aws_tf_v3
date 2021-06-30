#resource "aws_security_group" "admin" {
#  name        = var.admin_tag
#  description = "${var.admin_tag} sg"
#  ingress {
#    from_port       = 22
#    to_port         = 22
#    protocol        = "tcp"
#    cidr_blocks     = ["0.0.0.0/0"]
#    description     = "ssh"
#  }
#  ingress {
#    from_port       = 80
#    to_port         = 80
#    protocol        = "tcp"
#    cidr_blocks     = ["0.0.0.0/0"]
#    description     = "jenkins"
#  }
#  ingress {
#    from_port       = 3000
#    to_port         = 3000
#    protocol        = "tcp"
#    cidr_blocks     = ["0.0.0.0/0"]
#    description     = "zabbix"
#  }
#  ingress {
#    from_port       = 10050
#    to_port         = 10051
#    protocol        = "tcp"
#    cidr_blocks = [var.cidr,"52.198.4.141/32"]
#    description     = "zabbix"
#  }#

#  egress {
#    from_port       = 0
#    to_port         = 0
#    protocol        = "-1"
#    cidr_blocks     = ["0.0.0.0/0"]
#  }#

#  tags = {
#    Name = var.admin_tag
#  }
#}

resource "aws_security_group" "web" {
  name        = var.web_tag
  description = "${var.web_tag} sg"
  #vpc_id      = data.aws_vpc.default.id
  vpc_id = var.vpc_id
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    #security_groups = [aws_security_group.admin.id]
    security_groups = [var.admin_sg]
    description     = "admin only"
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    #cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sg.id]
    description     = "http"
  }
  ingress {
    from_port       = 10050
    to_port         = 10051
    protocol        = "tcp"
    #security_groups = [aws_security_group.admin.id]
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
    Name = var.web_tag
  }
}

#resource "aws_security_group" "bat" {
#  count = var.global_count
#  name        = var.bat_tag
#  description = "${var.bat_tag} sg"
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
#  egress {
#    from_port       = 0
#    to_port         = 0
#    protocol        = "-1"
#    cidr_blocks     = ["0.0.0.0/0"]
#  }
#  tags = {
#    Name = var.bat_tag
#  }
#}

resource "aws_security_group" "alb_sg" {
  name = "${var.web_tag}-alb"
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    #description     = ""
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    #description     = ""
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.web_tag}-alb"
  }
}

resource "aws_security_group" "db-sg" {
  name = var.db_tag
  vpc_id = var.vpc_id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.web.id,var.admin_sg]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.db_tag
  }
}

#resource "aws_security_group" "redis-sg" {
#    count = var.global_count
#    name = var.redis_tag
#    ingress {
#        from_port = 6379
#        to_port = 6379
#        protocol = "tcp"
#        security_groups = [aws_security_group.web.id,aws_security_group.admin.id,aws_security_group.bat.id]
#    }
#    egress {
#        from_port = 0
#        to_port = 0
#        protocol = "-1"
#        cidr_blocks = ["0.0.0.0/0"]
#    }
#    tags = {
#      Name = var.redis_tag
#    }
#}

#output "admin_sg_id" {
#  value = aws_security_group.admin.id
#}
#output "bat_sg_id" {
#  value = aws_security_group.bat.id
#}

output "web_sg_id" {
  value = aws_security_group.web.id
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
output "db_sg_id" {
  value = aws_security_group.db-sg.id
}