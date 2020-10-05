provider "azurerm" {
  subscription_id ="0ddfed24-adb8-4733-bf11-2c1a518f9ee7"
  tenant_id       = "3014603d-dc6a-45a2-b51e-d0ee2a89ad81"
  version = "=2.20.0"
  features {}
  skip_provider_registration = true
}

locals {
  resource_group                 = data.azurerm_resource_group.main.name
  databricks_vnet_id             = data.azurerm_virtual_network.main.id
  databricks_private_snet_name   = data.azurerm_subnet.private.name
  databricks_public_snet_name    = data.azurerm_subnet.public.name
}


resource "azurerm_databricks_workspace" "main" {
  name                = var.databricks_name
  resource_group_name = local.resource_group.name
  location            = local.resource_group.location
  sku                 = var.databricks_workspace_sku

  custom_parameters {
    no_public_ip        = var.no_public_ip
    virtual_network_id  = local.databricks_vnet_id
    public_subnet_name  = local.databricks_public_snet_name
    private_subnet_name = local.databricks_private_snet_name
  }
}
