#This is the most important file. It describes which resources Azure should create.


# Resource Group
resource "azurerm_resource_group" "weather" {
  name     = "rg-weather-k8s"
  location = var.location
}

# Azure Container Registry
resource "azurerm_container_registry" "weather" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.weather.name
  location            = azurerm_resource_group.weather.location
  sku                 = "Basic"
  admin_enabled       = false
}

# Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "weather" {
  name                = "aks-weather-demo"
  location            = azurerm_resource_group.weather.location
  resource_group_name = azurerm_resource_group.weather.name

  dns_prefix = "weatherdemo"
  sku_tier   = "Free"


  default_node_pool {
    name            = "system"
    node_count      = 1
    vm_size         = "Standard_D2as_v5"
    os_disk_size_gb = 30
    os_disk_type    = "Managed"

    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 2
    upgrade_settings {
      max_surge = "10%"
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
  }

  tags = {
    Environment = "Learning"
    Project     = "WeatherAPI"
  }
}

# Allow AKS to pull images from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.weather.id
  role_definition_name = "AcrPull"

  principal_id = azurerm_kubernetes_cluster.weather.kubelet_identity[0].object_id

  skip_service_principal_aad_check = true
}
