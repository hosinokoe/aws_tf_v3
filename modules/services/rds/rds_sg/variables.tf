variable "db_tag" {}
variable "db_type" {}
variable "db_name" {}
variable "db_user" {}
variable "db_pass" {}
variable "protect_enable" {}
variable "pf_enable" {}
variable "rds_az_enable" {}
variable "rds_az" { default = null }
# variable "db_sg_id" {}
variable "azs" {}
# variable "az1" {}
# variable "az2" {}
# variable "az3" { default = null }
variable "db_version" { default = "5.7.36" }
variable "db_para" { default = "5.7" }
variable "vpc_id" {}
variable "security_groups" {}
variable "ingress_rules_cidr" {}
# variable "matusi_sg" {}
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
    { name = "innodb_buffer_pool_instances", value = "1"},
    { name = "max_allowed_packet", value = "1073741824"},
    { name = "max_heap_table_size", value = "536870912"},
    { name = "table_open_cache", value = "2000"},
    { name = "tmp_table_size", value = "536870912"},
    { name = "long_query_time", value = "1.2"},
    { name = "slow_query_log", value = "1"},
    { name = "time_zone", value = "Asia/Tokyo"}]
}