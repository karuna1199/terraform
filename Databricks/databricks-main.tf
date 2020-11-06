provider "azurerm" {
  subscription_id ="573c7f56-43c4-4395-841b-003491c8ccc3"
  tenant_id       = "db05faca-c82a-4b9d-b9c5-0f64b6755421"
  version = "=2.20.0"
  features {}
  skip_provider_registration = true
}

resource "azurerm_databricks_workspace" "main" {
  name                = var.databricks_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_workspace_sku

  custom_parameters {
  #  no_public_ip        = var.no_public_ip
    virtual_network_id  = var.vnet_id
    #public_subnet_name  = local.databricks_public_snet_name
    private_subnet_name = var.databricks_private_subnet_name
  }
}