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
$parameterFilePath = "./VirtualNetwork/VirtualNetwork-Hub/vnet-template-parameters.$environment.json"

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
$parameterFilePath = "./VirtualNetwork/VirtualNetwork-Infra/vnet-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.spokeVirtualNetworkName.value = $spokeVirtualNetworkName
$paramContent.parameters.spokeVNetAddressPrefixes.value = $spokeVNetAddressPrefixes

$paramContent.parameters.subnetsData.value[0].name = $spokeInfraSubnetName
$paramContent.parameters.subnetsData.value[0].addressPrefixes = $spokeInfraSubnetAddressPrefix

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update vnet peering parameter file

# Path to the parameter file
$parameterFilePath = "./VirtualNetwork/VirtualNetworkPeering/vnetpeering-template-parameters.$environment.json"

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

#====================================================================================
# Update Azure Bastion Parameter File

# Path to the parameter file
$parameterFilePath = "./Bastion/bastion-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.bastionHostName.value = $bastionHostName
$paramContent.parameters.publicIPAddressName.value = $publicIPAddressesNames[1]
$paramContent.parameters.virtualNetworkName.value = $hubVirtualNetworkName

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update Application Gateway Parameter File

# Path to the parameter file
$parameterFilePath = "./ApplicationGateway/ag-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.applicationGatewayName.value = $applicationGatewayName
$paramContent.parameters.publicIPAddressName.value = $publicIPAddressesNames[0]
$paramContent.parameters.virtualNetworkName.value = $hubVirtualNetworkName
$paramContent.parameters.subNetName.value = $appGatewaySubnetName

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update Key Vault Parameter File

# Path to the parameter file
$parameterFilePath = "./Keyvault/kv-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.keyvaultName.value = $keyvaultName

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update storage account parameter file

# Path to the parameter file
$parameterFilePath = "./StorageAccount/sa-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.storageAccountName.value = $storageAccountName

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath

#====================================================================================
# Update private dns parameter file

# Path to the parameter file
$parameterFilePath = "./PrivateDNS/privatedns-template-parameters.$environment.json"

# Load the existing parameter file
$paramContent = Get-Content -Path $parameterFilePath | ConvertFrom-Json

# Update the parameter file content
$paramContent.parameters.privateDNSName.value = $privateDNSName
$paramContent.parameters.hubResourceGroupName.value = $rgHubName
$paramContent.parameters.hubVirtualNetworkName.value = $hubVirtualNetworkName
$paramContent.parameters.spokeVirtualNetworkName.value = $spokeVirtualNetworkName

# Save the updated parameter file back to disk
$paramContent | ConvertTo-Json -Depth 10 | Set-Content -Path $parameterFilePath