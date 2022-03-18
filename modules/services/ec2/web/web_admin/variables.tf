variable "ec2_ami" {}
variable "snapshot_id" { default = null }
variable "key" {}
variable "protect_enable" {}
variable "web_count" { type = number }
variable "web_type" {}
variable "web_tag" {}
variable "azs" {}

variable "vpc_id" {}
variable "admin_sg" {}
variable "alb_sg" {}
variable "alb_admin_sg" {}