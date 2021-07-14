terraform {
  required_version = "~>1.0"

  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "~>2.0" # pin the azure rm to compatible 2.0 (or higher version) version 
    }
    random = {
      source  = "random"
      version = "~>3.0"
    }
    time = {
      source  = "time"
      version = "~>0.7.2"
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
    CreationDateTime    = timeadd(time_static.createion_timestamp.rfc3339, "3h")


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
  location = var.location

  # Tags
  tags = local.common_tags

  lifecycle {
    ignore_changes = [
      tags["UTCCreationDateTime"], tags["CreationDateTime"], tags["Environment"]
    ]
  }
}

# Network

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.project_name}-network"
  location            = azurerm_resource_group.aks_resource_group.location
  resource_group_name = azurerm_resource_group.aks_resource_group.name
  address_space       = ["10.1.0.0/24"] #TODO: fix this to make some sense

  # Tags
  tags = local.common_tags

  lifecycle {
    ignore_changes = [
      tags["UTCCreationDateTime"], tags["CreationDateTime"], tags["Environment"]
    ]
  }
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  resource_group_name  = azurerm_resource_group.aks_resource_group.name
  address_prefixes     = ["10.1.0.0/25"]
}

# Logs

resource "azurerm_log_analytics_workspace" "new_log_analytics_workspace" {
  count               = var.new_log_analitics && var.log_analitics_workspace_address == null ? 1 : 0
  name                = "${var.project_name}-law"
  resource_group_name = azurerm_resource_group.aks_resource_group.name
  location            = azurerm_resource_group.aks_resource_group.location
  sku                 = "PerGB2018"

  # Tags
  tags = local.common_tags

  lifecycle {
    ignore_changes = [
      tags["UTCCreationDateTime"], tags["CreationDateTime"], tags["Environment"]
    ]
  }
}

resource "azurerm_log_analytics_solution" "new_log_analytics_solution" {
  count                 = var.new_log_analitics && var.log_analitics_workspace_address == null ? 1 : 0
  solution_name         = "Containers"
  workspace_resource_id = azurerm_log_analytics_workspace.new_log_analytics_workspace[0].id
  workspace_name        = azurerm_log_analytics_workspace.new_log_analytics_workspace[0].name
  location              = azurerm_resource_group.aks_resource_group.location
  resource_group_name   = azurerm_resource_group.aks_resource_group.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }

  # Tags
  tags = local.common_tags

  lifecycle {
    ignore_changes = [
      tags["UTCCreationDateTime"], tags["CreationDateTime"], tags["Environment"]
    ]
  }
}

locals {
  # if the user sent us log_analitics_workspace_address to configer use it else created one (that is created only if use user asked for it and didn't specify predifined log_analitics_workspace_address

  log_analytics_workspace_id = var.log_analitics_workspace_address != null ? var.log_analitics_workspace_address : var.new_log_analitics != false ? azurerm_log_analytics_workspace.new_log_analytics_workspace[0].id : null
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

  addon_profile {

    kube_dashboard {
      enabled = var.kube_dashboard
    }
    oms_agent {
      enabled                    = var.new_log_analitics
      log_analytics_workspace_id = local.log_analytics_workspace_id
    }
  }

  depends_on = [
    azurerm_log_analytics_workspace.new_log_analytics_workspace,
    # azurerm_log_analytics_solution.new_log_analytics_solution,
  ]

  # Tags
  tags = local.common_tags

  lifecycle {
    ignore_changes = [
      tags["UTCCreationDateTime"], tags["CreationDateTime"], tags["Environment"]
    ]
  }
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
