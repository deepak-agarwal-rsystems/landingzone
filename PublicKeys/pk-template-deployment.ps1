# Deploy the public IPs address
$templateFile = "./PublicKeys/pk-template.json"
$templateParameterFile = "./PublicKeys/pk-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile