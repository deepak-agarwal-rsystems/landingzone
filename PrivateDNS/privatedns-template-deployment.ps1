# Deploy Private DNS Zone
$templateFile = "./PrivateDNS/privatedns-template.json"
$templateParameterFile = "./PrivateDNS/privatedns-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgSpokeName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile