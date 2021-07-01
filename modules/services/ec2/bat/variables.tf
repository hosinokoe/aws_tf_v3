variable "ec2_ami" {}
variable "snapshot_id" { default = null }
variable "key" {}
variable "protect_enable" {}
variable "bat_count" { type = number }
variable "bat_type" {}
variable "bat_tag" {}
variable "az1" {}
variable "az2" {}
variable "az3" { default = null }
variable "bat_sg_id" {}