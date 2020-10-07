variable "name" {
  description = "The name of the kv that is being deployed"
  default = "example-kv01"
}
variable "location" {
  default = "east us"
}

variable "aks_rg_name" {
    default = "DefaultResourceGroup-EUS"
}

variable "aks_vnet_name" {
    default = "example-vn1"
}

variable "aks_vnet_rg_name" {
    default = "DefaultResourceGroup-EUS"
}

variable "aks_snet_name" {
    default = "default"
}

variable "environment" {
  description = "The name of the environment that is being deployed"
  default = "nonprod"
}
