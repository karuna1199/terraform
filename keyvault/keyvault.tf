provider "azurerm" {
  version = "=2.21.0"

  subscription_id = var.subscription_id
  client_id       = var.serviceprinciple_id
  client_secret   = var.serviceprinciple_key
  tenant_id       = var.tenant_id

  features {}
}

provider "azuread" {
  version = ">= 0.6"
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
  name                        = "u2-${var.environment}-kv"
  location                    = data.azurerm_resource_group.rg-u2k8s-test.location
  resource_group_name         = data.azurerm_resource_group.rg-u2k8s-test.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  sku_name = "standard"

  network_acls {
    default_action = "Allow"

    # 
    bypass = "AzureServices"

    # Enable ip_rules to access key vault for on-prem
    # ip_rules = [
    #   "12.163.96.0/24",
    #   "149.111.26.128/32",
    #   "149.111.28.128/32",
    #   "149.111.30.128/32",
    #   "161.249.144.14/32",
    #   "161.249.16.0/23",
    #   "161.249.176.14/32",
    #   "161.249.192.14/32",
    #   "161.249.72.14/32",
    #   "161.249.80.14/32",
    #   "161.249.96.14/32",
    #   "198.203.175.175/32",
    #   "198.203.177.177/32",
    #   "198.203.181.181/32",
    #   "203.39.148.18/32",
    #   "220.227.15.70/32",
    # ]

    # Enable this code block only if default_action is deny and specify which subnet can access kye vault
    # virtual_network_subnet_ids = [data.azurerm_subnet.sn-cr-ask-cradle-test.id]
  }

}

resource "azurerm_key_vault_access_policy" "tf_client" {
  key_vault_id = azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

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
