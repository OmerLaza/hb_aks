output "resource_group" {
  value = azurerm_resource_group.aks_resource_group.name
}

output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main_aks.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main_aks.kube_config
}

output "kube_admin_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main_aks.kube_admin_config
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.main_aks.id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.main_aks.fqdn
}

