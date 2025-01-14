param dbScopes array
param subscriptionScopes array
param infoActionGroupId string
param notificationActionGroupId string
param tags object = {}

resource processingRuleSuppressDbBackupAlerts 'Microsoft.AlertsManagement/actionRules@2023-05-01-preview' = {
  name: 'alpr-suppress-db-backup-warnings'
  location: 'global'
  tags: tags
  properties: {
    scopes: map(dbScopes, dbScope => dbScope.id)
    schedule: {
      timeZone: 'Eastern Standard Time'
      recurrences: [
        {
          recurrenceType: 'Daily'
          startTime: '03:00:00'
          endTime: '06:30:00'
        }
      ]
    }
    enabled: true
    actions: [
      {
        actionType: 'RemoveAllActionGroups'
      }
    ]
  }
}

resource processingRulesAssignNotificationsGroup 'Microsoft.AlertsManagement/actionRules@2023-05-01-preview' = {
  name: 'alpr-high-severity'
  location: 'global'
  tags: tags
  properties: {
    scopes: subscriptionScopes
    conditions: [
      {
        field: 'AlertRuleName'
        operator: 'DoesNotContain'
        values: [
          'Inactive VPN Tunnel Alert'
          'E2 Protocol-aggregate-alert'
        ]
      }
      {
        field: 'Severity'
        operator: 'Equals'
        values: [
          'Sev1'
          'Sev0'
        ]
      }
    ]
    enabled: true
    actions: [
      {
        actionType: 'AddActionGroups'
        actionGroupIds: [
          notificationActionGroupId
          infoActionGroupId
        ]
      }
    ]
  }
}

resource processingRulesAssignInfoGroup 'Microsoft.AlertsManagement/actionRules@2023-05-01-preview' = {
  name: 'alpr-low-severity'
  location: 'global'
  tags: tags
  properties: {
    scopes: subscriptionScopes
    conditions: [
      {
        field: 'severity'
        operator: 'Equals'
        values: [
          'Sev2'
        ]
      }
    ]
    enabled: true
    actions: [
      {
        actionType: 'AddActionGroups'
        actionGroupIds: [
          infoActionGroupId
        ]
      }
    ]
  }
}
