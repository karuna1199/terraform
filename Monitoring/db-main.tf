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
resource "azurerm_monitor_metric_alert" "db" {
name ="var.db_metric_alert_name"
resource_group_name = data.azurerm_resource_group.main.name
scopes = ["/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/newrg/providers/Microsoft.Sql/servers/ser-**/databases/db**"]
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