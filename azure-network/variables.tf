### Last edited by wojciech.bogucki@optum.com at ###

# Standard variables for resource locations and resource group names
variable "resource_group_name_dmz" { default = "rg-vnet-dmz-u2-test-cus-01" }
variable "resource_group_name_cradle" { default = "rg-vnet-u2-test-cus-01" }
variable "location" { default = "Central US" }
variable "resource_group_name_bastion" { default = "rg-bst-u2-test-cus-01"}

##########################
### VNETs and Subnets ###
##########################

# vnet-u2-dmz-test-cus-01 setup variables
variable "vnet_dmz_name" { default = "vnet-u2-dmz-test-cus-01" }
variable "sn_dmz_mgmt_bastion_name" { default = "AzureBastionSubnet" }
variable "sn_dmz_mgmt_appgateway_name" { default = "sn-u2-dmz-appgateway-test-cus-01" }

variable "vnet_dmz_range" { default = "172.17.0.0/20" }
variable "sn_dmz_mgmt_bastion_range" { default = "172.17.1.0/24" }
variable "sn_dmz_mgmt_appgateway_range" { default = "172.17.2.0/24" }


# vnet-u2-cr-test-cus-01 setup variables
variable "vnet_cr_aks_cradle_name" { default = "vnet-u2-cr-test-cus-01" }
variable "sn_cr_aks_cradle_name" { default = "sn-u2-cr-aks-test-cus-01" }
variable "sn_cr_keyvault_name" { default = "sn-u2-cr-keyvault-test-cus-01" }
variable "sn_cr_cosmosdb_name" { default = "sn-u2-cr-cosmosdb-test-cus-01" }
variable "sn_cr_mysql_name" { default = "sn-u2-cr-mysql-test-cus-01" }
variable "sn_cr_databricks_name" { default = "sn-u2-cr-databricks-test-cus-01" }

variable "vnet_cr_aks_cradle_range" { default = "10.100.0.0/16" }
variable "sn_cr_aks_cradle_range" { default = "10.100.0.0/22" }
variable "sn_cr_keyvault_range" { default = "10.100.10.0/24" }
variable "sn_cr_cosmosdb_range" { default = "10.100.20.0/24" }
variable "sn_cr_mysql_range" { default = "10.100.30.0/24" }
variable "sn_cr_databricks_range" { default = "10.100.40.0/24" }


#####################
### VNET Peerings ###
#####################

variable "peer_vnet_u2_cr_test_cus_01_to_vnet_u2_dmz_test_cus_01" { default = "peer-vnet-u2-cr-test-cus-01-to-vnet-u2-dmz-test-cus-01" }
variable "peer_vnet_u2_dmz_test_cus_01_to_vnet_u2_cr_test_cus_01" { default = "peer-vnet-u2-dmz-test-cus-01-to-vnet-u2-cr-test-cus-01" }

##################
### Public IPs ###
##################

variable "pip_u2_dmz_bastion_test_cus_01" { default = "pip-u2-dmz-bastion-test-cus-01" }

###############
### Bastion ###
###############

variable "bst_u2_dmz_test_cus_01" { default = "bst-u2-dmz-test-cus-01" }