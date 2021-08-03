resource "aws_security_group" "alb_sg" {
  name = "${var.ec2_tag.web_tag}-alb"
  vpc_id = data.aws_vpc.default.id
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
    Name = "${var.ec2_tag.web_tag}-alb sg"
  }
}

output "db_sg_id" {
  value = aws_security_group.db-sg.id
}