output "kube_config" {
    value = azurerm_kubernetes_cluster.aks-u2.kube_config_raw
}

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.aks-u2.kube_config.0.cluster_ca_certificate
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.aks-u2.kube_config.0.client_certificate
}

output "client_key" {
    value = azurerm_kubernetes_cluster.aks-u2.kube_config.0.client_key
}

output "host" {
    value = azurerm_kubernetes_cluster.aks-u2.kube_config.0.host
}

output "acr_repo" {
  value = azurerm_container_registry.acr.login_server
}