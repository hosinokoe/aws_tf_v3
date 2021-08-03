# 新建vpc时会新建路由表，不用特别再创建
resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name = "ap-northeast-1.compute.internal ${var.vpc_tag}"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

resource "aws_subnet" "public" {
  count = "${length(var.cidrs)}"
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.vpc_tag} public_${var.pub_tag[count.index]}"
  }
}

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = var.vpc_tag
#   }
# }

# resource "aws_default_route_table" "public" {
#   default_route_table_id = aws_vpc.main.default_route_table_id
#   tags = {
#     Name = var.vpc_tag
#   }
# }

resource "aws_route_table_association" "public" {
  count = "${length(var.cidrs)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  # route_table_id = "${aws_route_table.public.id}"
  route_table_id = aws_vpc.main.default_route_table_id
}

resource "aws_route" "default_route" {
  # route_table_id         = aws_route_table.public.id
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  # depends_on             = [aws_route_table.public]
}

# resource "aws_subnet" "main" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.cidr_a
#   map_public_ip_on_launch = true
#   availability_zone = "ap-northeast-1a"
#   tags = {
#     Name = "${var.vpc_tag} public_a"
#   }
# }

# resource "aws_subnet" "secd" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.cidr_c
#   map_public_ip_on_launch = true
#   availability_zone = "ap-northeast-1c"
#   tags = {
#     Name = "${var.vpc_tag} public_c"
#   }
# }

# resource "aws_subnet" "thrd" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.cidr_d
#   map_public_ip_on_launch = true
#   availability_zone = "ap-northeast-1d"
#   tags = {
#     Name = "${var.vpc_tag} public_d"
#   }
# }

output "vpc_id" {
  value = aws_vpc.main.id
}
output "azs" {
  value = aws_subnet.public.*.id
}