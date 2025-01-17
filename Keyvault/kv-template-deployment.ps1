# Deploy Key vault
$templateFile = "./Keyvault/kv-template.json"
$templateParameterFile = "./Keyvault/kv-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgSpokeName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile