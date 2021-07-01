variable "ec2_ami" {}
variable "snapshot_id" { default = null }
variable "key" {}
variable "protect_enable" {}
variable "web_count" { type = number }
variable "web_type" {}
variable "web_tag" {}
variable "az1" {}
variable "az2" {}
variable "az3" { default = null }
variable "web_sg_id" {}