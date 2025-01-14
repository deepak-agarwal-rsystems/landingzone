$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-p-001"
# $rgAIName = "rg-z-cplus-ai-p-001"
# $rgCustomerName = "rg-z-cplus-emrl-p-001"
# $sshKeyName = 'ssh-z-cplus-cus-ai-p-001'
# $rgDBName = "rg-z-cplus-db-p-001"
# $sshKeyName = 'ssh-z-cplus-cus-db-p-001'
# Customer Resource Group and Resources

# # Deploy the Infra Network Security Groups
# $templateFile = "./NetworkSecurityGroup-Infra/nsg-template.json"
# $templateParameterFile = "./NetworkSecurityGroup-Infra/nsg-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgInfraName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile $globalParameterFile
   
# #Deploy Infra Virtual Network
# $templateFile = "./VirtualNetwork-Infra/vnet-template.json"
# $templateParameterFile = "./VirtualNetwork-Infra/vnet-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgInfraName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile $globalParameterFile


#    $customers = @( @{'name'='hans';"size" = "Standard_D4s_v5"}, 
#    @{'name'='cobo';"size" = "Standard_D4s_v5"},
#    @{'name'='stva';"size" = "Standard_D4s_v5"}
#    )
   
#    foreach ( $customer in $customers ) {
#       $rgCustomerName = "rg-z-cust-$($customer.name)-p-001"
   
#       $templateFile = "./ResourceGroup/resourcegroup-template.json"
#       az deployment sub create `
#          --location $location `
#          --template-file $templateFile `
#          --parameters $globalParameterFile name=$rgCustomerName
   
#       # Deploy the Customer VM
#       $customerVMName = "vm-z-$($customer.name)-p"
#       $customerNICName = "$customerVMName-nic"
#       $customerSubNetName = "sn-z-cplus-$($customer.name)"
#       $templateFile = "./VirtualMachine/Customers/vm-customers-template.json"
#       $templateParameterFile = "./VirtualMachine/Customers/vm-customers-template-parameters.$environment.json"
#       az deployment group create `
#          --resource-group $rgCustomerName `
#          --template-file $templateFile `
#          --parameters $globalParameterFile $templateParameterFile virtualMachineName=$customerVMName networkInterfacesName=$customerNICName `
#          subnetName=$customerSubNetName infraResourceGroupName=$rgInfraName vmSize=$($customer.size)
#    }
   

# Deploy the Azure Kubernete Cluster
# $templateFile = "./Kubernete/aks-template.json"
# $templateParameterFile = "./Kubernete/aks-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgInfraName `
#    --template-file $templateFile `
#    --parameters $globalParameterFile $templateParameterFile

$templateFile = "./VirtualMachine/ExchangeServer/vm-exch-template.json"
$templateParameterFile = "./VirtualMachine/ExchangeServer/vm-exch-template-parameters.$environment.json"
$rgExchangeServer = "rg-z-cplusgw-exchange-p-001"
az deployment group create `
      --resource-group $rgExchangeServer `
      --template-file $templateFile `
      --parameters $globalParameterFile $templateParameterFile