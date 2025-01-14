param environment 'dev' | 'prod' = 'dev'
param tags object = {}
param rgCustPrefix string = 'rg-z-cust'
param location string = resourceGroup().location
param customerAbbr string = ''
param subdomain string = ''
param rootPath string = ''
param enableTestAlarmFlow bool = false
param enableTestE2Alarm bool = false
param enableTestCPlusLogin bool = false
param enableTestEmailFlow bool = false
param thresholdAlarmFlowTesting int = 0
param thresholdEmailTesting int = 0

var customer = [{
  subDomain: subdomain
  resourceTag: customerAbbr
  rootPath: rootPath
  enableTestAlarmFlow: enableTestAlarmFlow
  enableTestE2Alarm: enableTestE2Alarm
  enableTestCPlusLogin: enableTestCPlusLogin
  enableTestEmailFlow: enableTestEmailFlow
  thresholdAlarmFlowTesting: thresholdAlarmFlowTesting
  thresholdEmailTesting: thresholdEmailTesting
}]

var environmentTag = environment == 'dev' ? 'n' : 'p'

 //var customers = json(customer).value
 output customersRoot array = customer

module customerAlerts '../AzureMonitor/modules/customers.bicep' = {
  name: 'customer-insights'
  params: {
    location: location
    tags: tags
    environmentTag: environmentTag
    customers: customer
    rgCustPrefix: rgCustPrefix
  }
}
