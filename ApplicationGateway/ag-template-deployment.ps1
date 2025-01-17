# Deploy the application gateway
$templateFile = "./ApplicationGateway/ag-template.json"
$templateParameterFile = "./ApplicationGateway/ag-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile