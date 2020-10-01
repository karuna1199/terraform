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

resource "azurerm_monitor_metric_alert" "vm-cpu" {
name ="var.vm_metric_alert_name"
resource_group_name = data.azurerm_resource_group.main.name
scopes = ["/subscriptions/0ddfed24-adb8-4733-bf11-2c1a518f9ee7/resourceGroups/newrg/providers/Microsoft.Compute/virtualMachines/vm-company-advm01"]
description = "Action will be triggered when Transactions count is greater than 90."
severity = "1"
frequency = "PT5M"
window_size = "PT15M"

criteria {
metric_namespace = "Microsoft.Compute/virtualMachines"
metric_name = "var.vm_metric_name"
aggregation = "var.vm_aggregation"
operator = "var.vm_operator"
threshold = "var.vm_threshold"

}

action {
action_group_id = "${azurerm_monitor_action_group.main.id}"
}
}

resource "azurerm_monitor_metric_alert" "db" {
name ="var.db_metric_alert_name"
resource_group_name = data.azurerm_resource_group.main.name
scopes = ["/subscriptions/0ddfed24-adb8-4733-bf11-2c1a518f9ee7/resourceGroups/newrg/providers/Microsoft.Sql/servers/ser-company-ser01/databases/db-company-db01"]
description = "Action will be triggered when Transactions count is greater than 90."
frequency = "PT5M"

criteria {
metric_namespace = "Microsoft.Sql/servers/databases"
metric_name = "var.db_metric_name"
aggregation = "var.db_aggregation"
operator = "var.db_operator"
threshold = "var.db_threshold"

}

action {
action_group_id = "${azurerm_monitor_action_group.main.id}"
}
}
