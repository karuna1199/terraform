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

/*
data "azurerm_container_registry" "u2nonprod" {
  name                = "u2nonprod"
  resource_group_name = "rg-u2k8s-test"
}
*/

data "azurerm_user_assigned_identity" "test" {
  name                = "${azurerm_kubernetes_cluster.aks-u2.name}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.aks-u2.node_resource_group
}

data "azurerm_key_vault" "keyvault" {
  name                = "u2-${var.environment}-kv"
  resource_group_name = data.azurerm_resource_group.rg-u2k8s-test.name
}


#####################
# Resources section #
#####################


resource "azurerm_kubernetes_cluster" "aks-u2" {
  name                  = "u2-aks-${var.environment}"
  location              = data.azurerm_resource_group.rg-u2k8s-test.location
  resource_group_name   = data.azurerm_resource_group.rg-u2k8s-test.name
  dns_prefix            = "aks-${var.environment}"
  kubernetes_version    = var.kubernetes_version

  default_node_pool {
    name       = "default"
    min_count = 1
    max_count = 5
    vm_size    = "Standard_D2_v2"
    type       = "VirtualMachineScaleSets"
    os_disk_size_gb = 50
    enable_auto_scaling = true
    vnet_subnet_id = data.azurerm_subnet.sn-cr-ask-cradle-test.id
    node_labels = {
      "pool" = "infra"
    }
  }

identity {
    type = "SystemAssigned"
  }



  network_profile {
      network_plugin = "azure"
      network_policy = "azure"
      docker_bridge_cidr = "172.17.0.1/16"
      service_cidr       = "10.100.64.0/24"
      dns_service_ip     = "10.100.64.10"
      load_balancer_sku  = "Standard"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_log_workspace.id
    }


  }

/*  Ignore changes to the node_count argument that gets adjusted during scaling operations outside of Terraform */
    lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
     ]
    }


}

 resource "azurerm_kubernetes_cluster_node_pool" "apppool" {
   name                  = "u2apppool"
   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-u2.id
   vm_size               = "Standard_D2_v2"
   enable_auto_scaling   = true
   min_count             = 1
   max_count             = 5
   vnet_subnet_id        = data.azurerm_subnet.sn-cr-ask-cradle-test.id
   os_disk_size_gb       = 300
   os_type               = "Linux"
   node_labels = {
     "pool" = "u2app"
   }
 }



resource "azurerm_role_assignment" "vnet_aks" {
  scope                = data.azurerm_virtual_network.vnet-cr-aks-cradle-test.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-u2.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = data.azurerm_subnet.sn-cr-ask-cradle-test.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-u2.identity[0].principal_id
}


resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks-u2.kubelet_identity[0].object_id
}


resource "azurerm_role_assignment" "managed_identity_vm_write" {
  scope                = "${data.azurerm_subscription.current.id}/resourcegroups/${azurerm_kubernetes_cluster.aks-u2.node_resource_group}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-u2.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "managed_identity_aks" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.aks-u2.kubelet_identity[0].object_id
}



resource "azurerm_role_assignment" "omsagent_monitor_metrics" {
  scope                = azurerm_kubernetes_cluster.aks-u2.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.aks-u2.addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
}


resource "azurerm_log_analytics_workspace" "aks_log_workspace" {
  name                = "aks-u2-logs"
  resource_group_name = data.azurerm_resource_group.rg-u2k8s-test.name
  location            = data.azurerm_resource_group.rg-u2k8s-test.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_user_assigned_identity" "u2_aks_app_identity" {
  resource_group_name = data.azurerm_resource_group.rg-u2k8s-test.name
  location            = data.azurerm_resource_group.rg-u2k8s-test.location

  name = "u2-${var.environment}-u2-aks-app-identity"
}


# Allows the user assigned identity to access keyvault
resource "azurerm_key_vault_access_policy" "keyvault_access" {
  key_vault_id = data.azurerm_key_vault.keyvault.id

  tenant_id = var.tenant_id
  object_id = azurerm_user_assigned_identity.u2_aks_app_identity.principal_id

  secret_permissions = [
    "get",
    "list",
  ]

  certificate_permissions = []
  storage_permissions     = []
  key_permissions         = []
}