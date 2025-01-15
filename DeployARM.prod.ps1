# az login
# az account set --subscription "bd838b1b-c6fb-480b-a0d8-2ef04ce8c1db"  
# Prompt the user for dynamic values
#$environment = Read-Host "Enter value for parameter1"
#$location = Read-Host "Enter value for parameter2"

# Global Variables (Data need to collect from users)
$environment = "prod"
$location = "centralus"
$applicationName = "cplus"
$costCenterCode = "1108-300-8602"

# Tags parameters
$tags = @{"Environment" = $environment; "application" = $applicationName; "Cost Center Code" = $costCenterCode; }

# Resource Group parameters
$rgHubName = "rg-z-$applicationName-hub-p-001"
$rgSpokeName = "rg-z-$applicationName-spoke-p-001"

# Hub Virtual Network parameters
$hubVirtualNetworkName = "vnet-z-$applicationName-hub-p-001"
$appGatewaySubnetName = "sn-z-$applicationName-appgateway"
$hubResourceSubnetName = "sn-z-$applicationName-hubresource"
$hubVNetAddressPrefixes = @("10.195.72.0/22", "10.195.78.0/23")
$gatewaySubnetAddressPrefix = "10.195.72.0/24"
$bastionSubnetAddressPrefix = "10.195.73.0/26"
$appGatewaySubnetAddressPrefix = "10.195.73.64/26"
$hubResourceSubnetAddressPrefix = "10.195.74.0/24"

# Spoke Virtual Network parameters
$spokeVirtualNetworkName = "vnet-z-$applicationName-spoke-p-001"
$spokeVNetAddressPrefixes = @("10.195.64.0/21")
$spokeInfraSubnetName = "sn-z-$applicationName-infra"
$webResourceSubnetName = "sn-z-$applicationName-web"
$dbResourceSubnetName = "sn-z-$applicationName-db"
$spokeInfraSubnetAddressPrefix = "10.195.64.0/24"
$webResourceSubnetAddressPrefix = "10.195.65.0/28"
$dbResourceSubnetAddressPrefix = "10.195.65.16/28"

# Public IP parameters
$publicIPAddressesNames = @("pip-z-$applicationName-ag-p-001", "pip-z-$applicationName-bastion-p-001", "pip-z-$applicationName-gw-p-001")

# VPN Gateway parameters
$virtualNetworkGatewayName = "vpngw-z-$applicationName-hub-p-001"

# Prepare Parameter Files
& "./UpdateParameterFiles.ps1"

# Get Global Parameter File
$globalParameterFile = "./global-parameters.$environment.json"

#================================================================================
# Resource Groups

# Deploy the Hub Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
# az deployment sub create `
#    --location $location `
#    --template-file $templateFile `
#    --parameters $globalParameterFile name=$rgHubName

# Deploy the Spoke Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
# az deployment sub create `
#    --location $location `
#    --template-file $templateFile `
#    --parameters $globalParameterFile name=$rgSpokeName

#================================================================================
# Virtual Networks

# Deploy the Hub Virtual Network
$templateFile = "./VirtualNetwork-Hub/vnet-template.json"
$templateParameterFile = "./VirtualNetwork-Hub/vnet-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgHubName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile $globalParameterFile

# Deploy Spoke Virtual Network
$templateFile = "./VirtualNetwork-Infra/vnet-template.json"
$templateParameterFile = "./VirtualNetwork-Infra/vnet-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgSpokeName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile $globalParameterFile

# Peer Hub to Spoke Virtual Network
$templateFile = "./VirtualNetworkPeering/vnetpeering-hubtospoke-template.json"
$templateParameterFile = "./VirtualNetworkPeering/vnetpeering-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgSpokeName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile

# Peer Spoke to Hub Virtual Network
$templateFile = "./VirtualNetworkPeering/vnetpeering-spoketohub-template.json"
$templateParameterFile = "./VirtualNetworkPeering/vnetpeering-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgHubName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile

#================================================================================
# Public IPs

# Deploy the public IPs address
$templateFile = "./PublicKeys/pk-template.json"
$templateParameterFile = "./PublicKeys/pk-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

#================================================================================
# Virtual Network Gateways

# Deploy the Virtual Network Gateway
$templateFile = "./VPNGateway/vpngw-template.json"
$templateParameterFile = "./VPNGateway/vpngw-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile