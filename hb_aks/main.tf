terraform {
  required_version = ">= 0.15, < 0.16" # pin the Terraform version to 0.15.X 

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0" # pin the azure rm to compatible 2.0 (or higher version) version 
    }
  }
}

provider "azurerm" {
  features {}
}

resource "time_static" "createion_timestamp" {}


locals {
  # Basic tags are tags all resources should have not matter what
  basic_tags = {
    Project             = var.project_name
    Environment         = var.env
    UTCCreationDateTime = time_static.createion_timestamp.rfc3339
    #TODO: Covert to local timezone
  }
  # Common tags to be assigned to all resources
  common_tags = merge(var.tags, local.basic_tags) #the basic tags will override the user created tags
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  number  = true
}

resource "azurerm_resource_group" "aks_resource_group" {
  name     = "${var.project_name}-${random_string.random.result}"
  location = "West Europe"
}

# Network

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.project_name}-network"
  location            = azurerm_resource_group.aks_resource_group.location
  resource_group_name = azurerm_resource_group.aks_resource_group.name
  address_space       = ["10.1.0.0/24"] #TODO: fix this to make some sense
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  resource_group_name  = azurerm_resource_group.aks_resource_group.name
  address_prefixes     = ["10.1.0.0/25"]
}

# AKS

resource "azurerm_kubernetes_cluster" "main_aks" {
  name                = "${var.project_name}-k8s"
  dns_prefix          = "${var.project_name}-k8s"
  resource_group_name = azurerm_resource_group.aks_resource_group.name
  location            = azurerm_resource_group.aks_resource_group.location
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "default"
    node_count     = var.default_pool_number_of_instances
    vm_size        = var.default_pool_vm_size
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags

  addon_profile {
    kube_dashboard {
      enabled = false
    }
  }
}

# Spot

resource "azurerm_kubernetes_cluster_node_pool" "aks_spot" {
  # as this is MVP we support only one sport resource pool, in the future it should be expended to inclode N spot pools
  count                 = var.spot_config.spot_vm_number > 0 ? 1 : 0
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main_aks.id
  vm_size               = var.spot_config.spot_vm_size
  node_count            = var.spot_config.spot_vm_number
  priority              = "Spot"
  eviction_policy       = var.spot_config.spot_evection_policy
  spot_max_price        = var.spot_config.spot_max_price # note: this is the "maximum" price
  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }
  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]
}


# Network peering

resource "azurerm_virtual_network_peering" "connect_to_aks_aks2client" { #TODO: make this support N networks
  count = var.vent_peer == "" ? 0 : 1                                    #create only if var.vent_peer is not empty

  name                      = "aks2client"
  resource_group_name       = azurerm_resource_group.aks_resource_group.name
  virtual_network_name      = azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id = var.vent_peer
}

resource "azurerm_virtual_network_peering" "connect_to_aks_client2aks" { #TODO: make this support N networks
  count                     = var.vent_peer == "" ? 0 : 1                #create only if var.vent_peer is not empty
  name                      = "client2aks"
  resource_group_name       = split("/", var.vent_peer)[4]
  virtual_network_name      = split("/", var.vent_peer)[length(split("/", var.vent_peer)) - 1]
  remote_virtual_network_id = azurerm_virtual_network.aks_vnet.id
}
