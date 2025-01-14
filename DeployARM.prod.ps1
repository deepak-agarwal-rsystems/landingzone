# az login
# az account set --subscription "bd838b1b-c6fb-480b-a0d8-2ef04ce8c1db"  

# Global Variables
$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
#================================================================================
# Hub Resource Group and resources

# Deploy the Hub Resource Group
$rgHubName = "rg-z-cplus-gw-p-001"

# Deploy Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgHubName

# Deploy the Hub Network Security Groups
$templateFile = "./NetworkSecurityGroup-Hub/nsg-template.json"
$templateParameterFile = "./NetworkSecurityGroup-Hub/nsg-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

# Deploy Hub Virtual Network
$templateFile = "./VirtualNetwork-Hub/vnet-template.json"
$templateParameterFile = "./VirtualNetwork-Hub/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

# # Deploy the Public IPs
# $templateFile = "./PublicKeys/pk-template.json"
# $templateParameterFile = "./PublicKeys/pk-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgHubName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile $globalParameterFile

# # # Deploy the Bastion
# $templateFile = "./Bastion/bastion-template.json"
# $templateParameterFile = "./Bastion/bastion-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgHubName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile $globalParameterFile

#==================================================================================
# Infra Resource Group and Resources
$rgInfraName = "rg-z-cplus-infra-p-001"

# Deploy the Infra Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgInfraName

# Deploy the Infra Network Security Groups
$templateFile = "./NetworkSecurityGroup-Infra/nsg-template.json"
$templateParameterFile = "./NetworkSecurityGroup-Infra/nsg-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile
   
# Deploy Infra Virtual Network
$templateFile = "./VirtualNetwork-Infra/vnet-template.json"
$templateParameterFile = "./VirtualNetwork-Infra/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

#=============================================================================================
# AI Resource Group and Resources
$rgAIName = "rg-z-cplus-ai-p-001"
$sshKeyName = 'ssh-z-cplus-cus-ai-p-001'

# Create the resource group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgAIName

# Generate the SSH key
$templateFile = "./VirtualMachine/SSHTemplate/ssh-template.json"
$sshPublicKey = Get-Content "./VirtualMachine/public_ssh_key.pub" -Raw
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile sshKeyName=$sshKeyName sshPublicKeyValue=$sshPublicKey

# Deploy the AI reciver VM
$templateFile = "./VirtualMachine/Linux/vm-aire-template.json"
$templateParameterFile = "./VirtualMachine/Linux/vm-aire-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

# Deploy the ProAct service VM
$templateFile = "./VirtualMachine/Linux/vm-aise-template.json"
$templateParameterFile = "./VirtualMachine/Linux/vm-aise-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

# Deploy the redis VM
$templateFile = "./VirtualMachine/Linux/vm-redis-template.json"
$templateParameterFile = "./VirtualMachine/Linux/vm-redis-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

# # #=============================================================================================
# DB Resource Group and Resources

$rgDBName = "rg-z-cplus-db-p-001"
$sshKeyName = 'ssh-z-cplus-cus-db-p-001'

# Create the resource group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgDBName

# Generate the SSH key
$templateFile = "./VirtualMachine/SSHTemplate/ssh-template.json"
$sshPublicKey = Get-Content "./VirtualMachine/public_ssh_key.pub" -Raw
az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile `
   --parameters $globalParameterFile sshKeyName=$sshKeyName sshPublicKeyValue=$sshPublicKey

# Deploy the Oracle DB VM
$templateFile = "./VirtualMachine/Db/vm-orad-template.json"
$templateParameterFile = "./VirtualMachine/Db/vm-orad-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

# Deploy the SQL DB VM
$templateFile = "./VirtualMachine/Db/vm-sql-template.json"
$templateParameterFile = "./VirtualMachine/Db/vm-sql-template-parameters.$environment.json"
$vmSizes = @('Standard_E8as_v5', 'Standard_E8as_v5', 'Standard_E8as_v5', 'Standard_E20as_v5', 'Standard_E20as_v5', 'Standard_E8as_v5')
$noOfInstance = $vmSizes.count
$counter = 1
while($counter -le $noOfInstance)
{
   $vmName = "vm-z-sqld-p-$($counter.ToString('000'))"
   $nicName = "$vmName-nic"
   
   az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName `
   virtualMachineName=$vmName vmSize=$($vmSizes[$counter-1]) networkInterfacesName=$nicName

   $counter +=1
}

# #=============================================================================================
# Customer Resource Group and Resources

$customers = @( @{'name'='publ';"size" = "Standard_D4s_v5"}, 
@{'name'='emrl';"size" = "Standard_D4s_v5"},
@{'name'='huss';"size" = "Standard_D4s_v5"},
@{'name'='sdco';"size" = "Standard_D4s_v5"},
@{'name'='dscl';"size" = "Standard_D4s_v5"},
@{'name'='rsic';"size" = "Standard_D4s_v5"},
@{'name'='pens';"size" = "Standard_D4s_v5"},
@{'name'='bran';"size" = "Standard_D4s_v5"},
@{'name'='star';"size" = "Standard_D4s_v5"},
@{'name'='nsgs';"size" = "Standard_D4s_v5"},
@{'name'='plum';"size" = "Standard_D4s_v5"},
@{'name'='sulo';"size" = "Standard_D4s_v5"}
)

foreach ( $customer in $customers ) {
   $rgCustomerName = "rg-z-cust-$($customer.name)-p-001"

   $templateFile = "./ResourceGroup/resourcegroup-template.json"
   az deployment sub create `
      --location $location `
      --template-file $templateFile `
      --parameters $globalParameterFile name=$rgCustomerName

   # Deploy the Customer VM
   $customerVMName = "vm-z-$($customer.name)-p"
   $customerNICName = "$customerVMName-nic"
   $customerSubNetName = "sn-z-cplus-$($customer.name)"
   $templateFile = "./VirtualMachine/Customers/vm-customers-template.json"
   $templateParameterFile = "./VirtualMachine/Customers/vm-customers-template-parameters.$environment.json"
   az deployment group create `
      --resource-group $rgCustomerName `
      --template-file $templateFile `
      --parameters $globalParameterFile $templateParameterFile virtualMachineName=$customerVMName networkInterfacesName=$customerNICName `
      subnetName=$customerSubNetName infraResourceGroupName=$rgInfraName vmSize=$($customer.size)
}

# ======================================================================================

# Other Infra Resources

# Deploy Key vault
$templateFile = "./Keyvault/kv-template.json"
$templateParameterFile = "./Keyvault/kv-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy Storage Account
$templateFile = "./StorageAccount/sa-template.json"
$templateParameterFile = "./StorageAccount/sa-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

   # Deploy the Load Balancer
$templateFile = "./LoadBalancer/lb-template.json"
$templateParameterFile = "./LoadBalancer/lb-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy the Azure Kubernete Cluster
   $templateFile = "./Kubernete/aks-template.json"
   $templateParameterFile = "./Kubernete/aks-template-parameters.$environment.json"
   az deployment group create `
      --resource-group $rgInfraName `
      --template-file $templateFile `
      --parameters $globalParameterFile $templateParameterFile

# ========================================================================================
# Deploy other resources for Hub Resource Group
$rgHubName = "rg-z-cplus-gw-p-001"

# Deploy the API Management
$templateFile = "./APIManagementService/apim-template.json"
$templateParameterFile = "./APIManagementService/apim-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy the Application gateway
$templateFile = "./ApplicationGetway/ag-template.json"
$templateParameterFile = "./ApplicationGetway/ag-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy the VPN Gateway
$templateFile = "./VPNGateway/vpngw-template.json"
$templateParameterFile = "./VPNGateway/vpngw-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# ========================================================================================
$rgPentahoName = "rg-z-cplus-pent-p-001"

# Deploy the Pentaho VM
$templateFile = "./VirtualMachine/Pentaho/vm-pentaho-template.json"
$templateParameterFile = "./VirtualMachine/Pentaho/vm-pentaho-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgPentahoName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile


Write-Output "Done the Infra"

