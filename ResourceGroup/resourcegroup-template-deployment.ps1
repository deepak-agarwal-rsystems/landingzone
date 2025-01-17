# Deploy the Hub Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgHubName

# Deploy the Spoke Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgSpokeName