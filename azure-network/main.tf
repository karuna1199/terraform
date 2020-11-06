  
### Last edited by wojciech.bogucki@optum.com at ###

variable "client_secret" {
}

provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=2.4.0"

  subscription_id = "573c7f56-43c4-4395-841b-003491c8ccc3"
  client_id       = "92f3643a-a42e-46a4-9ed0-5d172d1a936f"
  client_secret   = var.client_secret
  tenant_id       = "db05faca-c82a-4b9d-b9c5-0f64b6755421"

  features {}
}


#########################
### VNETs and Subnets ###
#########################

# VNET vnet-u2-dmz-test-cus-01 setup for DMZ core network
resource "azurerm_virtual_network" "vnet-u2-dmz-test-cus-01" {
    name                = "${var.vnet_dmz_name}"
    address_space       = ["${var.vnet_dmz_range}"]
    location            = var.location
    resource_group_name = var.resource_group_name_dmz

    # Subnet sn-u2-dmz-bastion-test-cus-01 setup for Bastion Service
    subnet {
        name            = "${var.sn_dmz_mgmt_bastion_name}"
        address_prefix  = "${var.sn_dmz_mgmt_bastion_range}"
    }

    # Subnet sn-dmz-mgmt-appgateway setup for Application Gateways if needed
    subnet {
        name            = "${var.sn_dmz_mgmt_appgateway_name}"
        address_prefix  = "${var.sn_dmz_mgmt_appgateway_range}"
    }
}

# VNET vnet-cr-aks-cradle setup for main U2 services
resource "azurerm_virtual_network" "vnet-u2-cr-test-cus-01" {
    name                = "${var.vnet_cr_aks_cradle_name}"
    address_space       = ["${var.vnet_cr_aks_cradle_range}"]
    location            = var.location
    resource_group_name = var.resource_group_name_cradle

    # Subnet sn-cr-aks-cradle setup
    subnet {
        name            = "${var.sn_cr_aks_cradle_name}"
        address_prefix  = "${var.sn_cr_aks_cradle_range}"
    }

    # Subnet sn-cr-keyvault-cradle setup
    subnet {
        name            = "${var.sn_cr_keyvault_name}"
        address_prefix  = "${var.sn_cr_keyvault_range}"
    }

    # Subnet sn-cr-cosmosdb-cradle setup
    subnet {
        name            = "${var.sn_cr_cosmosdb_name}"
        address_prefix  = "${var.sn_cr_cosmosdb_range}"
    }

    # Subnet sn-cr-aks-cradle setup
    subnet {
        name            = "${var.sn_cr_mysql_name}"
        address_prefix  = "${var.sn_cr_mysql_range}"
    }

    # Subnet sn-cr-aks-cradle setup
    subnet {
        name            = "${var.sn_cr_databricks_name}"
        address_prefix  = "${var.sn_cr_databricks_range}"
    }
}


#####################
### VNET Peerings ###
#####################

# VNET peering between (vnet-u2-cr-test-cus-01 & vnet-u2-dmz-test-cus-01) between U2 Services vnet and U2 DMZ vnet
resource "azurerm_virtual_network_peering" "vnet-u2-cr-test-cus-01-to-vnet-u2-dmz-test-cus-01" {
    name                            = "${var.peer_vnet_u2_cr_test_cus_01_to_vnet_u2_dmz_test_cus_01}"
    resource_group_name             = azurerm_virtual_network.vnet-u2-cr-test-cus-01.resource_group_name
    virtual_network_name            = azurerm_virtual_network.vnet-u2-cr-test-cus-01.name
    remote_virtual_network_id       = azurerm_virtual_network.vnet-u2-dmz-test-cus-01.id
    allow_virtual_network_access    = true
    allow_forwarded_traffic         = false
    allow_gateway_transit           = false
}

# VNET peering between (vnet-u2-dmz-test-cus-01 & vnet-u2-cr-test-cus-01) between U2 DMZ vnet and U2 Services vnet
resource "azurerm_virtual_network_peering" "vnet-u2-dmz-test-cus-01-to-vnet-u2-cr-test-cus-01" {
    name                            = "${var.peer_vnet_u2_dmz_test_cus_01_to_vnet_u2_cr_test_cus_01}"
    resource_group_name             = azurerm_virtual_network.vnet-u2-dmz-test-cus-01.resource_group_name
    virtual_network_name            = azurerm_virtual_network.vnet-u2-dmz-test-cus-01.name
    remote_virtual_network_id       = azurerm_virtual_network.vnet-u2-cr-test-cus-01.id
    allow_virtual_network_access    = true
    allow_forwarded_traffic         = false
    allow_gateway_transit           = false
}


##################
### Public IPs ###
##################

# Setup Public IP Addresses
resource "azurerm_public_ip" "pip-u2-dmz-bastion-test-cus-01" {
    name                = "${var.pip_u2_dmz_bastion_test_cus_01}"
    resource_group_name = azurerm_virtual_network.vnet-u2-dmz-test-cus-01.resource_group_name
    location            = azurerm_virtual_network.vnet-u2-dmz-test-cus-01.location
    sku                 = "Standard"
    allocation_method   = "Static"
    ip_version          = "IPv4"
    domain_name_label   = "u2-dmz-bastion"
}


###############
### Bastion ###
###############

# Setup bastion
resource "azurerm_bastion_host" "bst-u2-dmz-test-cus-01" {
    name = "${var.bst_u2_dmz_test_cus_01}"
    resource_group_name = "${var.resource_group_name_bastion}"
    location = azurerm_virtual_network.vnet-u2-dmz-test-cus-01.location

    ip_configuration {
        name = "bst-u2-dmz-test-cus-01-config"
        subnet_id = "${element(azurerm_virtual_network.vnet-u2-dmz-test-cus-01.subnet[*].id,0)}"
        public_ip_address_id = azurerm_public_ip.pip-u2-dmz-bastion-test-cus-01.id
    }
}