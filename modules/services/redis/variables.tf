variable "redis_tag" {}
variable "redis_type" {}
variable "redis_para" { default = "6.x" }
variable "redis_version" { default = "6.x" }
variable "failover_enalbe" {}
variable "redis_az_enable" {}
variable "az1" {}
variable "az2" {}
variable "az3" { default = null }
variable "redis_sg_id" {}