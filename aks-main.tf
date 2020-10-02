provider "azurerm" {
  subscription_id ="0ddfed24-adb8-4733-bf11-2c1a518f9ee7"

  tenant_id       = "3014603d-dc6a-45a2-b51e-d0ee2a89ad81"
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
