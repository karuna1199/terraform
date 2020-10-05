# Required variables
variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group to deploy the Databricks workspace to."
  default = ""
}

variable "databricks_name" {
  type        = string
  description = "The name of a pre-existing log analytics workspace to stream logs to."
  default = ""
}

variable "databricks_virtual_network_name" {
  type        = string
  description = "The name of a pre-existing virtual network to provision the Databricks Workspace to."
  default = ""
}
variable "databricks_private_subnet_name" {
  type        = string
  description = "The name of the private Databricks sub net."
  default = ""
}

variable "databricks_public_subnet_name" {
  type        = string
  description = "The name of the public Databricks sub net."
  default = ""
}
variable "databricks_workspace_sku" {
  type        = string
  description = "The SKU of Databricks workspace to deploy. The choices are between standard and premium."
  default     = "standard"
}
variable "no_public_ip" {
  type        = bool
  description = "A boolean determining whether or not to initialise the Azure Databricks Workspace with a public IP address."
  #NOTE: Default to false here as not every Azure Subscription is by default capable of instantiating Databricks Workspaces with no public IP address. 
  default     = false
}
