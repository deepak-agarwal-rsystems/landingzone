
# Global Variables

# Deploy the Hub Resource Group
$rgPaloName = "rg-z-cplusgw-palo-asr-p-001"

# Deploy Resource Group
# $templateFile = "./ResourceGroup/resourcegroup-template.json"
# az deployment sub create `
#    --location $location `
#    --template-file $templateFile `
#    --parameters $globalParameterFile name=$rgPaloName


# az vm image terms accept --urn paloaltonetworks:vmseries-flex:byol:10.2.0

# Deploy the Hub Network Security Groups
$templateFile = "./PaloAlto/PaloAlto-DR.json"
az deployment group create `
   --resource-group $rgPaloName `
   --template-file $templateFile