provider "azurerm" {
  subscription_id ="0ddfed24-adb8-4733-bf11-2c1a518f9ee7"

  tenant_id       = "3014603d-dc6a-45a2-b51e-d0ee2a89ad81"
  version = "=2.20.0"
  features {}
  skip_provider_registration = true
}

########################
# Data sources section #
########################

/*
resource "azurerm_resource_group" "aks-k8s" {
  name     = var.resource_group_name
  location = var.location
}
*/

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg-u2k8s-test" {
  name = var.aks_rg_name
}

data "azurerm_virtual_network" "vnet-cr-aks-cradle-test" {
  name                = var.aks_vnet_name
  resource_group_name = var.aks_vnet_rg_name
}

data "azurerm_subnet" "sn-cr-ask-cradle-test" {
  name                 = var.aks_snet_name
  virtual_network_name = var.aks_vnet_name
  resource_group_name  = var.aks_vnet_rg_name
}

resource "azurerm_key_vault" "key_vault" {
  name                        = "u2-${var.name}-kv"
  location                    = data.azurerm_resource_group.rg-u2k8s-test.location
  resource_group_name         = data.azurerm_resource_group.rg-u2k8s-test.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  sku_name = "standard"

  network_acls {
    #default_action = "Allow"
    default_action = "Deny"
    bypass         = "AzureServices"

  }



 access_policy{
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = "7fc3345e-fdc9-4084-b638-34960de3ea40"

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
    "Get",
    "List"
  ]

  storage_permissions = []
}
}
#####PrivateLink###

resource "azurerm_private_endpoint" "pekv" {
  name                = "example-endpoint"
  location            = data.azurerm_resource_group.rg-u2k8s-test.location
  resource_group_name = data.azurerm_resource_group.rg-u2k8s-test.name
  subnet_id           = data.azurerm_subnet.sn-cr-ask-cradle-test.id
  depends_on         = [azurerm_key_vault.key_vault]
  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    is_manual_connection           = false
    subresource_names = ["Vault"]
  }

}
