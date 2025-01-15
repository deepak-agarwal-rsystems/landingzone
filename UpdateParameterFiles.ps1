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
$paramContent.parameters.hubVirtualNetworkName.value = $hubVirtualNetworkName
$paramContent.parameters.appGatewaySubnetName.value = $appGatewaySubnetName
$paramContent.parameters.hubVNetAddressPrefixes.value = $hubVNetAddressPrefixes
$paramContent.parameters.hubResourceSubnetName.value = $hubResourceSubnetName
$paramContent.parameters.gatewaySubnetAddressPrefix.value = $gatewaySubnetAddressPrefix
$paramContent.parameters.bastionSubnetAddressPrefix.value = $bastionSubnetAddressPrefix
$paramContent.parameters.appGatewaySubnetAddressPrefix.value = $appGatewaySubnetAddressPrefix
$paramContent.parameters.hubResourceSubnetAddressPrefix.value = $hubResourceSubnetAddressPrefix

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update Spoke VNet Parameter File

# Path to the parameter file
$parameterFilePath = "./VirtualNetwork-Infra/vnet-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.spokeVirtualNetworkName.value = $spokeVirtualNetworkName
$paramContent.parameters.spokeVNetAddressPrefixes.value = $spokeVNetAddressPrefixes

$paramContent.parameters.subnetsData.value[0].name = $spokeInfraSubnetName
$paramContent.parameters.subnetsData.value[0].addressPrefixes = $spokeInfraSubnetAddressPrefix

$paramContent.parameters.subnetsData.value[1].name = $webResourceSubnetName
$paramContent.parameters.subnetsData.value[1].addressPrefixes = $webResourceSubnetAddressPrefix

$paramContent.parameters.subnetsData.value[2].name = $dbResourceSubnetName
$paramContent.parameters.subnetsData.value[2].addressPrefixes = $dbResourceSubnetAddressPrefix

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update vnet peering parameter file

# Path to the parameter file
$parameterFilePath = "./VirtualNetworkPeering/vnetpeering-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.hubVnetName.value = $hubVirtualNetworkName
$paramContent.parameters.spokeVnetName.value = $spokeVirtualNetworkName
$paramContent.parameters.hubResourceGroupName.value = $rgHubName
$paramContent.parameters.spokeResourceGroupName.value = $rgSpokeName

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath
#====================================================================================
# Update public IPs parameter file

# Path to the parameter file
$parameterFilePath = "./PublicKeys/pk-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.publicIPAddressesNames.value = $publicIPAddressesNames

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update VPN Gateway parameter file

# Path to the parameter file
$parameterFilePath = "./VPNGateway/vpngw-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.virtualNetworkGatewayName.value = $virtualNetworkGatewayName
$paramContent.parameters.publicIPAddressName.value = $publicIPAddressesNames[2]
$paramContent.parameters.virtualNetworkName.value = $hubVirtualNetworkName

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath