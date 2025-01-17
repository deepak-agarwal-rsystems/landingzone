# Deploy the Virtual Network Gateway
$templateFile = "./VPNGateway/vpngw-template.json"
$templateParameterFile = "./VPNGateway/vpngw-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile