# Deploy the Bastion
$templateFile = "./Bastion/bastion-template.json"
$templateParameterFile = "./Bastion/bastion-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile