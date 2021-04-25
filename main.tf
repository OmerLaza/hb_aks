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

locals {
  # Basic tags are tags all resources should have not matter what
  basic_tags = {
    Project          = var.project_name
    Environment      = var.env
    CreationDateTime = timestamp()
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
  name     = "${var.project_name}_rg_${random_string.random.result}"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "main_aks" {
  name                = "${var.project_name}-k8s"
  dns_prefix          = "${var.project_name}-k8s"
  resource_group_name = azurerm_resource_group.aks_resource_group.name
  location            = azurerm_resource_group.aks_resource_group.location
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "default"
    node_count = var.default_pool_number_of_instances
    vm_size    = var.default_pool_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags

  addon_profile {
    kube_dashboard {
      enabled = var.kube_dashboard
    }
  }
}
