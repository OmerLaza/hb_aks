project_name = "TestAKS"
default_pool_vm_size = "Standard_D2_v2"
default_pool_number_of_instances = 3
env = "test"

vent_peer = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/RESOURCE_GROUP_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME"

tags = {
    xyz= "abc"
    American= "Pie"
}

# this is optional and need to be added only if you want to add spot instances to the basic AKS
spot_config = {
    spot_vm_number       = 1 # If configred to be 0 no spot will be created
    spot_vm_size         = "Standard_NC6"
    spot_evection_policy = "Delete"
    spot_max_price       = -1 # in USD, -1 for any price up to the on demend price (the regular price)
  }