#This displays useful resource information after deployment.


output "resource_group_name" {
  value = azurerm_resource_group.weather.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.weather.name
}

output "acr_login_server" {
  value = azurerm_container_registry.weather.login_server
}
