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
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }
}

resource "azurerm_monitor_metric_alert" "vm-cpu" {
name ="vm-cpu-metric-alert"
resource_group_name = data.azurerm_resource_group.main.name
scopes = ["/subscriptions/0ddfed24-adb8-4733-bf11-2c1a518f9ee7/resourceGroups/newrg/providers/Microsoft.Compute/virtualMachines/vm-company-advm01"]
description = "Action will be triggered when Transactions count is greater than 90."
severity = "1"
frequency = "PT5M"
window_size = "PT15M"

criteria {
metric_namespace = "Microsoft.Compute/virtualMachines"
metric_name = "Percentage CPU"
aggregation = "Average"
operator = "GreaterThan"
threshold = 90

}

action {
action_group_id = "${azurerm_monitor_action_group.main.id}"
}
}

resource "azurerm_monitor_metric_alert" "db" {
name ="db-metric-alert"
resource_group_name = data.azurerm_resource_group.main.name
scopes = ["/subscriptions/0ddfed24-adb8-4733-bf11-2c1a518f9ee7/resourceGroups/newrg/providers/Microsoft.Sql/servers/ser-company-ser01/databases/db-company-db01"]
description = "Action will be triggered when Transactions count is greater than 90."
frequency = "PT5M"

criteria {
metric_namespace = "Microsoft.Sql/servers/databases"
metric_name = "storage_percent"
aggregation = "Maximum"
operator = "GreaterThan"
threshold = 50

}

action {
action_group_id = "${azurerm_monitor_action_group.main.id}"
}
}