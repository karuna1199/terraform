
data "azurerm_subnet" "sn-ask" {
  name                 = var.aks_snet_name
  virtual_network_name = var.aks_vnet_name
  resource_group_name  = var.aks_vnet_rg_name
}

resource "azurerm_container_registry" "acr" {
  name                = "u2${var.environment}"
  resource_group_name = var.acr_rg_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false
  network_rule_set {
    default_action = "Deny"

    
    #bypass = "AzureServices"


    # Enable this code block only if default_action is deny and specify which subnet can access kye vault
      virtual_network {
       action = "Allow"
       subnet_id = data.azurerm_subnet.sn-ask.id
     }
   }
}