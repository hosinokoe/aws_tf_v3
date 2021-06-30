variable "ec2_ami" {}
variable "snapshot_id" {}
variable "key" {}
variable "admin_type" {}
variable "admin_tag" {}
variable "admin_count" { type = number }
variable "protect_enable" {}
variable "web_count" { type = number }
variable "web_type" {}
variable "web_tag" {}
variable "bat_count" { type = number }
variable "bat_type" {}
variable "bat_tag" {}
variable "az1" {}
variable "az2" {}
variable "az3" {}
variable "vpc_id" {}
variable "global_count" { type = number }
variable "alb_cert" {}
#variable "admin_sg_id" {}
variable "web_sg_id" {}
variable "alb_sg_id" {}
#variable "bat_sg_id" {}