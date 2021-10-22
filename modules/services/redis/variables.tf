variable "redis_tag" {}
variable "redis_type" {}
variable "redis_para" { default = "6.x" }
variable "redis_version" { default = "6.x" }
variable "failover_enalbe" {}
variable "redis_az_enable" {}
variable "azs" {}
variable "security_groups" {}
variable "vpc_id" {}
variable "sns_display_name" {}
# variable "az3" { default = null }
# variable "redis_sg_id" {}