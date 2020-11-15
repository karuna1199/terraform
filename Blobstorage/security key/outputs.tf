output "storage_account_name" {
  description = "The name of the storage account."
  value       = var.storage_account_name
}

output "Access_key" {
  value = data.azurerm_storage_account.demo.primary_access_key
}
