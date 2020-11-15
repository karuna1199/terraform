terraform {
  required_version = ">= 0.12.6"
}

provider "azurerm" {
  subscription_id ="573c7f56-43c4-4395-841b-003491c8ccc3"
  tenant_id       = "db05faca-c82a-4b9d-b9c5-0f64b6755421"
  version = "=2.36.0"  
  skip_provider_registration = true
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

resource "azurerm_storage_account" "storeacc" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = true

  blob_properties {
    delete_retention_policy {
      days = var.soft_delete_retention
    }
  }
  

  dynamic "network_rules" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action             = "Deny"
      bypass                     = ["AzureServices"]
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.subnet_ids
    }
  }

  tags = var.tags
}
