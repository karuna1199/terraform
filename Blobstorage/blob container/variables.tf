variable "name" {
}

variable "storage_account_name" {
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
}

variable "containers" {
type = list(object({ name = string, access_type = string }))
}

variable "events" {
}

variable "tags" {
}

variable "lifecycles" {
}

