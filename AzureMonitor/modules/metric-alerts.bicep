param location string
param tags object = {}
param alertConditions array
param resourceId string
param resourceName string

resource metricAlertConditions 'Microsoft.Insights/metricAlerts@2018-03-01' = [for condition in alertConditions: {
  name: '${condition.name}-${resourceName}'
  location: 'global'
  tags: tags
  properties: {
    autoMitigate: condition.severity >= 2 // Do not auto-mitigate critical (Sev0, Sev1) events
    criteria: {
      allOf: [
        {
          ...condition
          severity: null // Remove severity from condition object as it's only used below
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    description: ''
    enabled: true
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    scopes: [resourceId]
    severity: condition.severity
    targetResourceRegion: location
    targetResourceType: condition.metricNamespace
  }
}]
