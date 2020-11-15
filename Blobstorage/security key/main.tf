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

data "azurerm_storage_account" "demo" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

