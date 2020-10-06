variable "serviceprinciple_id" {
  default = "92f3643a-a42e-46a4-9ed0-5d172d1a936f"
}

variable "serviceprinciple_key" {
}

variable "tenant_id" {
  default = "db05faca-c82a-4b9d-b9c5-0f64b6755421"
}

variable "subscription_id" {
  default = "573c7f56-43c4-4395-841b-003491c8ccc3"
}

variable "location" {
  default = "centralus"
}

variable "aks_rg_name" {
    default = "rg-aks-u2-test-cus-01"
}

variable "aks_vnet_name" {
    default = "vnet-u2-cr-test-cus-01"
}

variable "aks_vnet_rg_name" {
    default = "rg-vnet-u2-test-cus-01"
}

variable "aks_snet_name" {
    default = "sn-u2-cr-aks-test-cus-01"
}

variable "acr_rg_name" {
    default = "rg-acr-u2-test-cus-01"
}


variable "environment" {
  description = "The name of the environment that is being deployed"
  default = "nonprod"
}
