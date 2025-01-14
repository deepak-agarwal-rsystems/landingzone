param (
    [string]$customerPrefix,
    [string]$subdomain,
    [string]$rootPath,
    [bool]$enableTestAlarmFlow,
    [bool]$enableTestE2Alarm,
    [bool]$enableTestCPlusLogin,
    [bool]$enableTestEmailFlow
)

$environment = "prod"
$rgDeployTarget="rg-z-cplus-monit-p-001"

az deployment group create `
   --resource-group $rgDeployTarget `
   --template-file './Customer/customer-alert.bicep' `
   --parameters `
        environment=$environment `
        customerAbbr=$customerPrefix `
        subdomain=$subdomain `
        rootPath=$rootPath `
        enableTestAlarmFlow=$enableTestAlarmFlow `
        enableTestE2Alarm=$enableTestE2Alarm `
        enableTestCPlusLogin=$enableTestCPlusLogin `
        enableTestEmailFlow=$enableTestEmailFlow `
        thresholdAlarmFlowTesting=30 `
        thresholdEmailTesting=30
