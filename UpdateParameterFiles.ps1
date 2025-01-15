# Update Global Parameter File
# Path to the parameter file
$parameterFilePath = "./global-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.tags.value = $tags
$paramContent.parameters.location.value = $location

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update Hub VNet Parameter File
# Path to the parameter file
$parameterFilePath = "./VirtualNetwork-Hub/vnet-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.virtualNetworkName.value = $virtualNetworkName
$paramContent.parameters.appGatewaySubnetName.value = $appGatewaySubnetName
$paramContent.parameters.hubVNetAddressPrefixes.value = $hubVNetAddressPrefixes
$paramContent.parameters.hubResourceSubnetName.value = $hubResourceSubnetName
$paramContent.parameters.gatewaySubnetAddressPrefix.value = $gatewaySubnetAddressPrefix
$paramContent.parameters.bastionSubnetAddressPrefix.value = $bastionSubnetAddressPrefix
$paramContent.parameters.appGatewaySubnetAddressPrefix.value = $appGatewaySubnetAddressPrefix
$paramContent.parameters.hubResourceSubnetAddressPrefix.value = $hubResourceSubnetAddressPrefix

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath