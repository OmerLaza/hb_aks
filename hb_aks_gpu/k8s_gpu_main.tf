terraform {
  required_version = ">= 0.15, < 0.16" # pin the Terraform version to 0.15.X 

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0" # pin the azure rm to compatible 2.0 (or higher version) version 
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.1"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "aks_data" {
  name                = var.aks_name
  resource_group_name = var.aks_resource_group
}

provider "kubernetes" {

  host                   = data.azurerm_kubernetes_cluster.aks_data.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_data.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_data.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_data.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "gpu-resources" {
  metadata {
    name = "gpu-resources"
  }
}

resource "kubernetes_daemonset" "gpu-resources" {
  # api_version= "v1"
  # "kind"= "DaemonSet"
  metadata {
    name      = "nvidia-device-plugin-daemonset"
    namespace = "gpu-resources"
    # namespace = "kube-system"
  }
  spec {
    selector {
      match_labels = {
        name = "nvidia-device-plugin-ds"
      }
    }
    strategy {
      type = "RollingUpdate"
    }
    template {
      metadata {
        annotations = {
          "scheduler.alpha.kubernetes.io/critical-pod" = ""
        }
        labels = {
          name = "nvidia-device-plugin-ds"
        }
      }
      spec {
        toleration {

          key      = "CriticalAddonsOnly"
          operator = "Exists"

        }
        toleration {

          key      = "nvidia.com/gpu"
          operator = "Exists"
          effect   = "NoSchedule"

        }
        container {
          image = "mcr.microsoft.com/oss/nvidia/k8s-device-plugin=1.11"
          name  = "nvidia-device-plugin-ctr"
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = [
                "ALL"
              ]
            }
          }
          volume_mount {
            name       = "device-plugin"
            mount_path = "/var/lib/kubelet/device-plugins"
          }

        }
        volume {
          name = "device-plugin"
          host_path {
            path = "/var/lib/kubelet/device-plugins"
          }
        }

      }
    }
  }

}


