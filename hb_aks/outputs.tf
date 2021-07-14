output "resource_group" {
  value = azurerm_resource_group.aks_resource_group.name
}

output "location" {
  value = azurerm_resource_group.aks_resource_group.location
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

output "aks_name" {
  value = split("/", azurerm_kubernetes_cluster.main_aks.id)[length(split("/", azurerm_kubernetes_cluster.main_aks.id)) - 1]
}

output "log_analitics_workspace_id" {
  value = local.log_analytics_workspace_id
}

output "project_name" {
  value = var.project_name
}

output "common_tags"{
  value = local.common_tags
}
