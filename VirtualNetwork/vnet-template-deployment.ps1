# Deploy the Hub Virtual Network
$templateFile = "./VirtualNetwork/VirtualNetwork-Hub/vnet-template.json"
$templateParameterFile = "./VirtualNetwork/VirtualNetwork-Hub/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

# Deploy Spoke Virtual Network
$templateFile = "./VirtualNetwork/VirtualNetwork-Infra/vnet-template.json"
$templateParameterFile = "./VirtualNetwork/VirtualNetwork-Infra/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgSpokeName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile
