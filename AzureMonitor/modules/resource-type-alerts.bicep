param location string
param tags object
param resourceType 'vm' | 'ag' | 'vnet' | 'lb' | 'aks'
param resourceIds array = []
param alertConditions array = []

module metricAlerts 'metric-alerts.bicep' = [for resource in resourceIds: {
  name: '${resourceType}-${resource.name}-metricAlerts'
  params: {
    location: location
    tags: tags
    resourceId: resource.id
    resourceName: resource.name
    alertConditions: alertConditions
  }
}]
