# az login
# az account set --subscription "bd838b1b-c6fb-480b-a0d8-2ef04ce8c1db"  
# Prompt the user for dynamic values
#$environment = Read-Host "Enter value for parameter1"
#$location = Read-Host "Enter value for parameter2"

# Global Variables (Data need to collect from users)
$environment = "prod"
$location = "centralus"
$applicationName = "cpru"
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
$spokeInfraSubnetAddressPrefix = "10.195.64.0/24"

# virtual machine parameters
# VM Name must be 4 characters or less
$virtualMachines = @( 
   @{"OSType" = "Windows"; "vmName" = "Web"; "vmSize" = "Standard_D4s_v5"; "subnetAddressPrefix" = "10.195.65.0/28"; "adminUserName" = "azureuser"; "adminPassword" = "Copeland@123"; "numberOfInstance" = 1 ; "startingVMNumber" = 1 }
   @{"OSType" = "Windows"; "vmName" = "Web"; "vmSize" = "Standard_D8s_v5"; "subnetAddressPrefix" = "10.195.65.0/28"; "adminUserName" = "azureuser"; "adminPassword" = "Copeland@123"; "numberOfInstance" = 2 ; "startingVMNumber" = 2 }
   @{"OSType" = "Windows"; "vmName" = "Web"; "vmSize" = "Standard_D2s_v5"; "subnetAddressPrefix" = "10.195.65.0/28"; "adminUserName" = "azureuser"; "adminPassword" = "Copeland@123"; "numberOfInstance" = 2 ; "startingVMNumber" = 4 }
   #@{"OSType" = "Windows"; "vmName" = "SQL"; "vmSize" = "Standard_D8s_v5"; "subnetAddressPrefix" = "10.195.65.16/28"; "adminUserName" = "azureuser"; "adminPassword" = "Copeland@123"; "numberOfInstance" = 2; "startingVMNumber" = 3 }
   #@{"OSType" = "Linux"; "vmName" = "linux"; "vmSize" = "Standard_D4s_v3"; "subnetAddressPrefix" = "10.195.65.16/28"; "adminUserName" = "azureuser"; "adminPassword" = "Copeland@123"; "numberOfInstance" = 2; "startingVMNumber" = 3 }
)

# Public IP parameters
$publicIPAddressesNames = @("pip-z-$applicationName-ag-p-001", "pip-z-$applicationName-bastion-p-001", "pip-z-$applicationName-gw-p-001")

# VPN Gateway parameters
$virtualNetworkGatewayName = "vpngw-z-$applicationName-hub-p-001"

# Azure Bastion parameters
$bastionHostName = "bastion-z-$applicationName-p-001"

# Application Gateway parameters
$applicationGatewayName = "ag-z-$applicationName-p-001"

# Key Vault parameters
$keyvaultName = "kv-z-$applicationName-spoke-p-001"

# Storage Account parameters
$storageAccountName = "saz$($applicationName)spoke001"

# Private DNS parameters
$privateDNSName = "privatedns-z-$applicationName-spoke-p-001.com"

# Prepare Parameter Files
& "./UpdateParameterFiles.ps1"

# Get Global Parameter File
$globalParameterFile = "./global-parameters.$environment.json"

#================================================================================
# Deploy Resource Groups
#& "./ResourceGroup/resourcegroup-template-deployment.ps1"

#================================================================================
# Deploy Virtual Networks
#& "./VirtualNetwork/vnet-template-deployment.ps1"

#================================================================================
# Deploy Public IPs
#& "./PublicKeys/pk-template-deployment.ps1"

#================================================================================
# Deploy Virtual Network Gateways
#& "./VPNGateway/vpngw-template-deployment.ps1"

#================================================================================
# Deploy Virtual Network Peering
#& "./VirtualNetwork/vnet-peering-deployment.ps1"

#================================================================================
# Deploy Azure Bastion
#& "./Bastion/bastion-template-deployment.ps1"

#================================================================================
# Deploy Application Gateway 
#& "./ApplicationGateway/ag-template-deployment.ps1"

#================================================================================
# Spoke Infra Resources

# Deploy Key vault
#& "./Keyvault/kv-template-deployment.ps1"

# Deploy Storage Account
#& "./StorageAccount/sa-template-deployment.ps1"

# Deploy Private DNS
#& "./PrivateDNS/privatedns-template-deployment.ps1"

#================================================================================
# Deploy Spoke Virtual Machines

foreach ( $virtualMachine in $virtualMachines ) {
   & "./VirtualMachine/Customers/vm-customers-template-deployment.ps1"
   #& "./VirtualMachine/Db/vm-sql-template-deployment.ps1"
}