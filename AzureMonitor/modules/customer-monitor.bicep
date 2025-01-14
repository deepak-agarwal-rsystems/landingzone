param location string
param tags object = {}
param customer object = {}
param environmentTag 'n' | 'p'
param logAnalyticsWorkspaceId string

func isLowSeverityTest(testName string) bool => contains(testName, 'Email Monitor')

resource customerAppInsights 'Microsoft.Insights/components@2020-02-02' = {
  // Substring here is for calculating the customer resourceTag from the name 
  // Customer resourceTag is expected to be in the format of 'appi-z-[resourceTag]-n-001'
  name: 'appi-z-${substring(customer.name, 10, 4)}-${environmentTag}-001'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
}

resource webTests 'Microsoft.Insights/webtests@2022-06-15' = [
  for webTest in customer.webTests: {
    name: '${webTest.name}'
    location: location
    tags: union(tags, {
      'hidden-link:${customerAppInsights.id}': 'Resource'
    })
    kind: 'standard'
    properties: {
      Name: '${webTest.name}'
      SyntheticMonitorId: '${webTest.name}'
      Kind: 'standard'
      Enabled: webTest.enabled
      Frequency: 300
      Locations: [
        {
          Id: 'latam-br-gru-edge'
        }
        {
          Id: 'us-fl-mia-edge'
        }
        {
          Id: 'us-tx-sn1-azr'
        }
        {
          Id: 'apac-jp-kaw-edge'
        }
        {
          Id: 'emea-se-sto-edge'
        }
      ]
      Request: {
        HttpVerb: webTest.httpVerb ?? 'GET'
        ParseDependentRequests: false
        RequestUrl: webTest.request
        RequestBody: webTest.requestBody
        Headers: webTest.headers
      }
      RetryEnabled: true
      Timeout: 120
      ValidationRules: {
        ContentValidation: {
          ContentMatch: webTest.validationRules
          IgnoreCase: false
          PassIfTextFound: true
        }
        ExpectedHttpStatusCode: 200
        SSLCertRemainingLifetimeCheck: 7
        SSLCheck: true
        IgnoreHttpStatusCode: webTest.ignoreHttpStatusCode
      }
    }
  }
]

resource webTestAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = [
  // Filter out alerts that have a null webTestId
  for alert in customer.webTestAlerts: if (!empty(alert.webTestId)) {
    name: '${alert.name}'
    location: 'global'
    tags: union(tags, {
      'hidden-link:${customerAppInsights.id}': 'Resource'
      'hidden-link:${alert.webTestId}': 'Resource'
    })
    properties: {
      enabled: alert.enabled ?? true
      criteria: {
        'odata.type': 'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
        webTestId: alert.webTestId
        componentId: customerAppInsights.id
        failedLocationCount: alert.failedLocationCount ?? 2
      }
      scopes: [
        alert.webTestId
        customerAppInsights.id
      ]
      windowSize: alert.windowSize ?? 'PT5M'
      evaluationFrequency: alert.evaluationFrequency ?? 'PT5M'
      severity: alert.severity ?? 2
    }
    dependsOn: [webTests]
  }
]

resource webTestAggregateAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = [
  // Only create alerts for aggregate tests
  for alert in customer.webTestAlerts: if (contains(alert.name, 'aggregate')) {
    name: '${alert.name}'
    location: 'global'
    tags: union(tags, {
      'hidden-link:${customerAppInsights.id}': 'Resource'
    })
    properties: {
      autoMitigate: isLowSeverityTest(alert.webTestName)
      enabled: alert.enabled ?? true
      criteria: {
        'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
        allOf: [
          {
            name: 'Metric1'
            threshold: 0
            metricName: 'availabilityResults/availabilityPercentage'
            metricNamespace: 'Microsoft.Insights/components'
            operator: 'LessThanOrEqual'
            timeAggregation: 'Average'
            criterionType: 'StaticThresholdCriterion'
            dimensions: [
              {
                name: 'availabilityResult/name'
                operator: 'Include'
                values: [
                  alert.webTestName
                ]
              }
            ]
          }
        ]
      }
      scopes: [
        customerAppInsights.id
      ]
      windowSize: alert.windowSize ?? 'PT30M'
      evaluationFrequency: alert.evaluationFrequency ?? 'PT30M'
      // Email Monitor Severity can't totally be trusted since users can set it off with a bug
      severity: isLowSeverityTest(alert.webTestName) ? 2 : 1
    }
    dependsOn: [webTests]
  }
]
