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

module "hb_aks" {
  source                           = "./hb_aks/"
  location                         = var.location
  project_name                     = var.project_name
  default_pool_vm_size             = var.default_pool_vm_size
  default_pool_number_of_instances = var.default_pool_number_of_instances
  env                              = var.env
  tags                             = var.tags
  kubernetes_version               = var.kubernetes_version
  vent_peer                        = var.vent_peer
}
