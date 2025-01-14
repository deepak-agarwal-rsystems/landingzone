param actionGroupWebHookUrl string
param tags object = {}
param environment 'dev' | 'prod' = 'dev'
param location string = resourceGroup().location
param rgCustPrefix string = 'rg-z-cust'
param appGatewayIds array = []
param loadBalancerIds array = []
param vnetIds array = []
param aksIds array = []
param dbVmIds array = []

var rgWebTests = loadJsonContent('../customers.json')
var environmentTag = environment == 'dev' ? 'n' : 'p'

// Low priority action groups for capturing and inspecting alerts
resource infoActionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: 'ag-info'
  location: 'global'
  properties: {
    enabled: true
    groupShortName: 'ag-info'
    emailReceivers: [
      {
        emailAddress: 'deepak.agarwal@rsystems.com'
        name: 'RsystemsDeepakEmail'
        useCommonAlertSchema: false
      }
      {
        emailAddress: 'sonik.laroiya@rsystems.com'
        name: 'RsystemsSonikEmail'
        useCommonAlertSchema: false
      }
      {
        emailAddress: 'sukhi.singh@rsystems.com'
        name: 'RSystemsSukhiEmail'
        useCommonAlertSchema: false
      }
      {
        emailAddress: 'alex.heck@copeland.com'
        name: 'CopelandAlexEmail'
        useCommonAlertSchema: false
      }
      {
        emailAddress: 'jacob.crandall@copeland.com'
        name: 'CopelandJacobEmail'
        useCommonAlertSchema: false
      }
      {
        emailAddress: 'azure-alerts-aaaancvah3t7bcvhfk5nh4erji@copeland-software.slack.com'
        name: 'SlackEmail'
        useCommonAlertSchema: false
      }
      {
        emailAddress: 'hindeep.khatter@rsystems.com'
        name: 'RSystemsHindeepEmail'
        useCommonAlertSchema: false
      }
      {
        emailAddress: 'amardeep.pundhir@rsystems.com'
        name: 'RsystemsAmardeepEmail'
        useCommonAlertSchema: false
      }
    ]
  }
  tags: tags
}

// High priority action group for alerting pager duty
resource notificationActionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: 'NotificationActionGroup'
  location: 'global'
  properties: {
    enabled: true
    groupShortName: 'ag-notify'
    webhookReceivers: [
      {
        name: 'pgd-on-call'
        serviceUri: actionGroupWebHookUrl
        useCommonAlertSchema: true
      }
    ]
  }
  tags: tags
}

var alertConditions = [
  {
    threshold: 95
    name: 'alm-cpu-percentage'
    metricNamespace: 'microsoft.compute/virtualmachines'
    metricName: 'Percentage CPU'
    operator: 'GreaterThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 2
  }
  {
    threshold: 250000000 //.25 GB
    name: 'alm-available-memory'
    metricNamespace: 'microsoft.compute/virtualmachines'
    metricName: 'Available Memory Bytes'
    operator: 'LessThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 2
  }
  {
    threshold: 1000000000 //1 GB
    name: 'alm-disk-writes'
    metricNamespace: 'microsoft.compute/virtualmachines'
    metricName: 'OS Disk Write Bytes/sec'
    operator: 'GreaterThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 3
  }
  {
    threshold: 500 //ms
    name: 'alm-disk-latency'
    metricNamespace: 'microsoft.compute/virtualmachines'
    metricName: 'OS Disk Latency'
    operator: 'GreaterThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 3
  }
  {
    threshold: 200 // per/s
    name: 'alm-disk-read'
    metricNamespace: 'microsoft.compute/virtualmachines'
    metricName: 'OS Disk Read Operations/Sec'
    operator: 'GreaterThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 3
  }
  {
    threshold: 0 // 1 = available, 0 = unavailable
    name: 'alm-vm-available'
    metricNamespace: 'microsoft.compute/virtualmachines'
    metricName: 'VmAvailabilityMetric'
    operator: 'LessThanOrEqual'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 2
  }
]

var applicationGatewayAlertConditions = [
  {
    threshold: 5000 //ms
    name: 'alm-byte-response-time'
    metricNamespace: 'Microsoft.Network/applicationgateways'
    metricName: 'BackendFirstByteResponseTime'
    operator: 'GreaterThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 3
  }
  {
    threshold: 50
    name: 'alm-failed-requests'
    metricNamespace: 'Microsoft.Network/applicationgateways'
    metricName: 'FailedRequests'
    operator: 'GreaterThan'
    timeAggregation: 'Total'
    criterionType: 'StaticThresholdCriterion'
    severity: 2
  }
]

var loadBalancerAlertConditions = [
  {
    threshold: 99
    name: 'alm-backend-availability'
    metricNamespace: 'Microsoft.Network/loadBalancers'
    metricName: 'DipAvailability'
    operator: 'LessThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 2
  }
]

var virtualNetworkAlertConditions = [
  {
    threshold: 0
    name: 'alm-under-ddos-attack'
    metricNamespace: 'Microsoft.Network/VirtualNetworks'
    metricName: 'IfUnderDDoSAttack'
    operator: 'GreaterThan'
    timeAggregation: 'Maximum'
    criterionType: 'StaticThresholdCriterion'
    severity: 2
  }
  {
    threshold: 5000
    name: 'alm-ping-average-round-trip'
    metricNamespace: 'Microsoft.Network/VirtualNetworks'
    metricName: 'PingMeshAverageRoundtripMs'
    operator: 'LessThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 4
  }
  {
    threshold: 0
    name: 'alm-ping-failed-percent'
    metricNamespace: 'Microsoft.Network/VirtualNetworks'
    metricName: 'PingMeshProbesFailedPercent'
    operator: 'GreaterThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 3
  }
]

var aksAlertConditions = [
  {
    threshold: 95
    name: 'aks-cpu-percentage'
    metricNamespace: 'Microsoft.ContainerService/managedClusters'
    metricName: 'node_cpu_usage_percentage'
    operator: 'GreaterThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 2
  }
  {
    threshold: 95
    name: 'aks-memory-percentage'
    metricNamespace: 'Microsoft.ContainerService/managedClusters'
    metricName: 'node_memory_working_set_percentage'
    operator: 'GreaterThan'
    timeAggregation: 'Average'
    criterionType: 'StaticThresholdCriterion'
    severity: 2
  }
]

module loadBalancerLevelAlertConditions 'modules/resource-type-alerts.bicep' = {
  name: 'lb-level-alert-rules'
  params: {
    location: location
    tags: tags
    resourceType: 'lb'
    alertConditions: loadBalancerAlertConditions
    resourceIds: loadBalancerIds
  }
}

module vnetLevelAlertConditions 'modules/resource-type-alerts.bicep' = {
  name: 'vnet-level-alert-rules'
  params: {
    location: location
    tags: tags
    resourceType: 'vnet'
    alertConditions: virtualNetworkAlertConditions
    resourceIds: vnetIds
  }
}

module appGatewayLevelAlertConditions 'modules/resource-type-alerts.bicep' = {
  name: 'ag-level-alert-rules'
  params: {
    location: location
    tags: tags
    resourceType: 'ag'
    alertConditions: applicationGatewayAlertConditions
    resourceIds: appGatewayIds
  }
}

module aksLevelAlertConditions 'modules/resource-type-alerts.bicep' = {
  name: 'aks-level-alert-rules'
  params: {
    location: location
    tags: tags
    resourceType: 'aks'
    alertConditions: aksAlertConditions
    resourceIds: aksIds
  }
}

module subscriptionLevelAlertConditons 'modules/metric-alerts.bicep' = {
  name: 'subscription-level-alert-rules'
  params: {
    location: location
    alertConditions: alertConditions
    tags: tags
    resourceId: subscription().id
    resourceName: 'sub'
  }
}

module customerAlerts 'modules/customers.bicep' = {
  name: 'customer-insights'
  params: {
    location: location
    tags: tags
    environmentTag: environmentTag
    rgCustPrefix: rgCustPrefix
    customers: rgWebTests
  }
}

module processingAlertRules 'modules/processing-rules.bicep' = {
  name: 'processing-rules'
  params: {
    dbScopes: dbVmIds
    subscriptionScopes: [subscription().id]
    tags: tags
    infoActionGroupId: infoActionGroup.id
    notificationActionGroupId: notificationActionGroup.id
  }
}

output notificationActionGroupId string = notificationActionGroup.id
output infoActionGroupId string = infoActionGroup.id
