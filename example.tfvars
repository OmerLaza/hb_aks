project_name = "TestAKS"
default_pool_vm_size = "Standard_D2_v2"
default_pool_number_of_instances = 3
env = "test"

vent_peer = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/RESOURCE_GROUP_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME"

tags = {
    xyz= "abc"
    American= "Pie"
}