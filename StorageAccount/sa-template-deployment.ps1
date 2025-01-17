# Deploy Storage Account
$templateFile = "./StorageAccount/sa-template.json"
$templateParameterFile = "./StorageAccount/sa-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgSpokeName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile