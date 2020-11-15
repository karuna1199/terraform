terraform {
  required_version = ">= 0.12.6"
}

provider azurerm {
  version = "~> 2.36.0"
  features {}
}

provider random {
  version = "~> 2.2"
}

locals {
  default_event_rule = {
    event_delivery_schema = null
    topic_name            = null
    labels                = null
    filters               = null
    eventhub_id           = null
    service_bus_topic_id  = null
    service_bus_queue_id  = null
    included_event_types  = null
  }

  merged_events = [for event in var.events : merge(local.default_event_rule, event)]
}

resource "azurerm_storage_container" "storage" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = var.storage_account_name
  container_access_type = var.containers[count.index].access_type
}
