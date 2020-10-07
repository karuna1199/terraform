provider "azurerm" { 
  version = "~>2.0"
  features {}
}
module "azure-resource-group" {
  source  = "./../../modules/azure-resource-group"
  name =  "Test-Group" 
}