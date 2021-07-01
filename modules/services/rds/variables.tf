variable "db_tag" {}
variable "db_type" {}
variable "db_name" {}
variable "db_user" {}
variable "db_pass" {}
variable "protect_enable" {}
variable "pf_enable" {}
variable "rds_az_enable" {}
variable "rds_az" { default = null }
variable "db_sg_id" {}
variable "az1" {}
variable "az2" {}
variable "az3" { default = null }
variable "db_version" { default = "5.7.31" }
variable "db_para" { default = "5.7" }
#variable "vpc_id" {}
#variable "web_sg" {}
#variable "admin_sg" {}
#variable "bat_sg" {}

variable "parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = [{ name = "character_set_client", value = "utf8"},
    { name = "character_set_connection", value = "utf8"},
    { name = "character_set_database", value = "utf8"},
    { name = "character_set_results", value = "utf8"},
    { name = "character_set_server", value = "utf8"},
    { name = "collation_connection", value = "utf8_general_ci"},
    { name = "collation_server", value = "utf8_general_ci"},
    { name = "long_query_time", value = "1.2"},
    { name = "slow_query_log", value = "1"},
    { name = "time_zone", value = "Asia/Tokyo"}]
}