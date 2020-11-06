provider "azurerm" {
  subscription_id ="573c7f56-43c4-4395-841b-003491c8ccc3"

  tenant_id       = "db05faca-c82a-4b9d-b9c5-0f64b6755421"
  version = "=2.20.0"
  features {}
  skip_provider_registration = true
}


data "azurerm_resource_group" "main" {
  name     = "var.rg_name"
}

resource "azurerm_monitor_action_group" "main" {
  name                = "var.action_group_name"
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = "p0action"
  
  webhook_receiver {
    name        = "var.webhook_receiver_name"
    service_uri = "var.webhook_service_uri"
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert" {
  name                = "var.aks_metric_alert_name"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = ["/subscriptions/0ddfed24-adb8-4733-bf11-2c1a518f9ee7/resourcegroups/testrg/providers/Microsoft.ContainerService/managedClusters/test-rg-node"]
  description         = "Alert will be triggered when avg utilization is more than 80%"

  criteria {
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "var.aks_metric_name"
    aggregation      = "var.aks_aggregation"
    operator         = "var.aks_operator"
    threshold        = "var.aks_threshold"

    dimension {
      name     = "Host"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}