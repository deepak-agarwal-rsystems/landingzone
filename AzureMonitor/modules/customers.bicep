param location string
param tags object = {}
param environmentTag 'n' | 'p' = 'n'
param customers array = []
param rgCustPrefix string

resource globalLogWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-z-cplus-${environmentTag}-001'
  location: location
  tags: tags
  properties: {
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 30
    workspaceCapping: {
      dailyQuotaGb: -1
    }
  }
}

module customerModule './customer-monitor.bicep' = [
  for customer in customers: {
    // Need to take a substring of 4 characters starting at the 10th index of customer.name
    name: 'appi-z-${substring(customer.name, 10, 4)}-${environmentTag}-001'
    scope: resourceGroup('${rgCustPrefix}-${substring(customer.name, 10, 4)}-${environmentTag}-001')
    params: {
      location: location
      tags: tags
      customer: customer
      environmentTag: environmentTag
      logAnalyticsWorkspaceId: globalLogWorkspace.id
    }
  }
]
