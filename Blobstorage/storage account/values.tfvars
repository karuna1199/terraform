name = "blobu2storage"
resource_group_name = "rg-sa-u2-test-cus-01"
location = "centralus"
account_tier = "Standard"
account_replication_type = "ZRS"
access_tier = "Hot"
soft_delete_retention = 31
enable_advanced_threat_protection = true
network_rules = {
ip_rules = ["168.183.0.0/16", "149.111.0.0/16", "128.35.0.0/16", "161.249.0.0/16", "198.203.174.0/23", "198.203.176.0/22", "198.203.180.0/23", "12.163.96.0/24", "198.203.175.183", "198.203.177.183", "198.203.181.183"]
subnet_ids = ["/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-cr-test-cus-01/subnets/sn-u2-cr-aks-test-cus-01", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-cr-test-cus-01/subnets/sn-u2-cr-aks-test-cus-02", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-cr-test-cus-01/subnets/sn-u2-cr-cosmosdb-test-cus-01", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-cr-test-cus-01/subnets/sn-u2-cr-databricks-priv-test-cus-01", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-cr-test-cus-01/subnets/sn-u2-cr-databricks-pub-test-cus-01", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-cr-test-cus-01/subnets/sn-u2-cr-keyvault-test-cus-01", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-cr-test-cus-01/subnets/sn-u2-cr-mysql-test-cus-01", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-dmz-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-dmz-test-cus-01/subnets/AzureBastionSubnet", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-dmz-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-dmz-test-cus-01/subnets/sn-u2-dmz-appgateway-test-cus-01", "/subscriptions/573c7f56-43c4-4395-841b-003491c8ccc3/resourceGroups/rg-vnet-dmz-u2-test-cus-01/providers/Microsoft.Network/virtualNetworks/vnet-u2-dmz-test-cus-01/subnets/sn-u2-dmz-jumpservers-test-cu-01"]
}
events = []
tags = {tag: "s3-blob"}
lifecycles = []

