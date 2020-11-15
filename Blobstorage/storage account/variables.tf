variable "name" {
}

variable "resource_group_name" {
}

variable "location" {
}

variable "account_tier" {
}

variable "account_replication_type" {
}

variable "access_tier" {
}

variable "soft_delete_retention" {
}

variable "enable_advanced_threat_protection" {
}

variable "network_rules" {
type = object({ ip_rules = list(string), subnet_ids = list(string) })
}

variable "events" {
}

variable "tags" {
}

variable "lifecycles" {
}

