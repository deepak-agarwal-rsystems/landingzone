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

# Hub Virtual Network parameters
$virtualNetworkName = "vnet-z-$applicationName-hub-p-001"
$appGatewaySubnetName = "sn-z-$applicationName-appgateway"
$hubResourceSubnetName = "sn-z-$applicationName-hubresource"
$hubVNetAddressPrefixes = @("10.195.72.0/22", "10.195.78.0/23")
$gatewaySubnetAddressPrefix = "10.195.72.0/24"
$bastionSubnetAddressPrefix = "10.195.73.0/26"
$appGatewaySubnetAddressPrefix = "10.195.73.64/26"
$hubResourceSubnetAddressPrefix = "10.195.74.0/24"

# Calculated parameters
$tags = @{"Environment" = $environment; "application" = $applicationName; "Cost Center Code" = $costCenterCode; }

# Global Parameters
& "./UpdateParameterFiles.ps1"
$globalParameterFile = "./global-parameters.$environment.json"

#================================================================================
# Resource Groups

# Deploy the Hub Resource Group
$rgHubName = "rg-z-$applicationName-hub-p-001"

$templateFile = "./ResourceGroup/resourcegroup-template.json"
# az deployment sub create `
#    --location $location `
#    --template-file $templateFile `
#    --parameters $globalParameterFile name=$rgHubName

# Deploy the Spoke Resource Group
$rgSpokeName = "rg-z-$applicationName-spoke-p-001"

# Deploy the Infra Resource Group
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

# Deploy Infra Virtual Network
$templateFile = "./VirtualNetwork-Infra/vnet-template.json"
$templateParameterFile = "./VirtualNetwork-Infra/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile