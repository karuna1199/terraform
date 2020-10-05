data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "main" {
  name                = var.databricks_virtual_network_name
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "private" {
  name                 = var.databricks_private_subnet_name
  virtual_network_name = data.azurerm_virtual_network.main.name
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "public" {
  name                 = var.databricks_public_subnet_name
  virtual_network_name = data.azurerm_virtual_network.main.name
  resource_group_name = data.azurerm_resource_group.main.name
}
