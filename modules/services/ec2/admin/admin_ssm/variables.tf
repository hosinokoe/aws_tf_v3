variable "ec2_ami" {}
variable "snapshot_id" { default = null }
variable "key" {}
variable "protect_enable" {}
variable "admin_type" {}
variable "admin_tag" {}
variable "az1" {}

variable "vpc_id" {}
variable "ingress_rules_cidr" {}
variable "egress_rules" {}