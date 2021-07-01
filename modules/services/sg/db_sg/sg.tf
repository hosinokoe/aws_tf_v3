resource "aws_security_group" "db-sg" {
  name = var.db_tag
  vpc_id = var.vpc_id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [var.web_sg,var.bat_sg,var.admin_sg]
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

output "db_sg_id" {
  value = aws_security_group.db-sg.id
}