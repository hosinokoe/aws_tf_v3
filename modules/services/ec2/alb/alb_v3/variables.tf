variable "alb_tag" {}
variable "web_count" { type = number }
variable "target_id" {}
variable "azs" {}
variable "vpc_id" {}
variable "protect_enable" {}
variable "alb_cert" {}
variable "instance_port" { default = 80 }