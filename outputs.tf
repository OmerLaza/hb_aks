
output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main_aks.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.main_aks.kube_config_raw
}
