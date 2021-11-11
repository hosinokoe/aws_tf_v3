variable "ec2_ami" {}
variable "snapshot_id" { default = null }
variable "key" {}
variable "protect_enable" {}
variable "ftp_count" { type = number }
variable "ftp_type" {}
variable "ftp_tag" {}
variable "azs" {}

variable "vpc_id" {}
variable "admin_sg" {}