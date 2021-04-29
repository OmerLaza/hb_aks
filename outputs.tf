
output "client_certificate" {
  sensitive = true
  value     = module.hb_aks.client_certificate
}

output "kube_config" {
  # sensitive = true
  value = module.hb_aks.kube_config
}

output "kube_admin_config" {
  sensitive = true
  value = module.hb_aks.kube_admin_config
}

output "aks_id" {
  value = module.hb_aks.aks_id
}

output "aks_fqdn" {
  value = module.hb_aks.aks_fqdn
}

