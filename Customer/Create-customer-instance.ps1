param (
    [string]$customerPrefix,
    [string]$subnetIPRange,
    [string]$vmSize
)

#Hardcoded Variables
$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$vnetName = "vnet-z-cplus-p-001"
$rgInfraName = "rg-z-cplus-infra-p-001"
$rgDeployTarget="rg-z-cplus-monit-p-001"

$rgCustomerName = "rg-z-cust-$($customerPrefix)-p-001"
$templateFile = "./ResourceGroup/resourcegroup-template.json"

# Create the resource group
az deployment sub create `
    --location $location `
    --template-file $templateFile `
    --parameters $globalParameterFile name=$rgCustomerName

# Apply delete lock on the Resource Group
# az lock create `
# --name "DeleteLock" `
# --resource-group $rgCustomerName `
# --lock-type CanNotDelete `
# --notes "This lock prevents accidental deletion of the resource group"

# Create the NSG
$nsgName = "nsg-z-cplus-$($customerPrefix)-p-001"
az network nsg create `
    --resource-group $rgCustomerName `
    --name $nsgName `
    --location $location

# # Create the Subnet
$subnetName = "sn-z-cplus-$($customerPrefix)"
az network vnet subnet create `
    --resource-group $rgInfraName `
    --vnet-name $vnetName `
    --name $subnetName `
    --address-prefixes $subnetIPRange

# Apply NSG to the Subnet
# Get the NSG resource ID
$nsgResourceId = (az network nsg show --resource-group $rgCustomerName --name $nsgName --query id --output tsv)

# # Update the subnet with NSG
az network vnet subnet update `
    --resource-group $rgInfraName `
    --vnet-name $vnetName `
    --name $subnetName `
    --network-security-group $nsgResourceId

# Declare and set the variables for customer VM 
$customerVMName = "vm-z-$($customerPrefix)-p"
$customerNICName = "$customerVMName-nic"
$templateFile = "./VirtualMachine/Customers/vm-customers-template.json"
$templateParameterFile = "./VirtualMachine/Customers/vm-customers-template-parameters.$environment.json"

# # Deploy the customer VM
az deployment group create `
   --resource-group $rgCustomerName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile virtualMachineName=$customerVMName networkInterfacesName=$customerNICName `
   subnetName=$subnetName infraResourceGroupName=$rgInfraName vmSize=$vmSize