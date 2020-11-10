terraform {
  required_version = ">= 0.12.6"
}

provider azurerm {
  version = "~> 2.12.0"
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

resource "azurerm_storage_management_policy" "storage" {
  count = length(var.lifecycles) == 0 ? 0 : 1

  storage_account_id = azurerm_storage_account.storage.id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }
      actions {
        base_blob {
          delete_after_days_since_modification_greater_than = rule.value.delete_after_days
        }
      }
    }
  }
}